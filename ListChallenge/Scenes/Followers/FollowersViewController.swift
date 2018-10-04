//
//  FollowersViewController.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 02/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import Kingfisher

class FollowersViewController: UIViewController {

    @IBOutlet weak var colView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private let defaultCellHeight: CGFloat = 245
    private let defaultCellSpacing: CGFloat = 16
    private let numberOfColumns: CGFloat = 2
    
    var transition: PopAnimator?
    var selectedFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var viewModel: FollowersViewModel?
    var followers: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        configureCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureCollectionView() {
        colView.delegate = self
        colView.collectionViewLayout = BouncyLayout(style: .prominent)
        colView.refreshControl = UIRefreshControl()
        colView.register(UINib(nibName: FollowerCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
    }
    
    // MARK: - Bind -
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .asDriverOnErrorJustComplete()
            .mapToVoid()
        
        let pull = colView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let itemSelected = colView.rx
            .itemSelected
            .do(onNext: {
                indexPath in
                let theAttributes:UICollectionViewLayoutAttributes! = self.colView.layoutAttributesForItem(at: indexPath)
                self.selectedFrame = self.colView.convert(theAttributes.frame, to: self.colView.superview)
            })
            .asDriverOnErrorJustComplete()
        
        let input = FollowersViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                             selection: itemSelected)
        
        let output = viewModel.transform(input: input)

        output.followers.drive(colView.rx.items(cellIdentifier: FollowerCollectionViewCell.reuseID, cellType: FollowerCollectionViewCell.self)) {
            index, model, cell in
            cell.bindViewModel(model)
        }
        .disposed(by: disposeBag)
        
        output.fetching
            .drive(colView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.selectedFollower
            .do(onNext: { user in
                if let profilePicURL = URL(string: user.profilePicture ?? "https://www.ischool.berkeley.edu/sites/default/files/default_images/avatar.jpeg") {
                    let imageView = UIImageView(frame: self.selectedFrame)
                    imageView.kf.setImage(with: profilePicURL)
                    self.transition = PopAnimator(duration: 0.5, isPresenting: true, originFrame: self.selectedFrame, image: imageView.image!)
                }
            })
            .asDriver()
            .drive()
            .disposed(by: disposeBag)
    }
}

// MARK: - FlowLayout -
extension FollowersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/numberOfColumns - (defaultCellSpacing * numberOfColumns), height: defaultCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: defaultCellSpacing, left: defaultCellSpacing, bottom: defaultCellSpacing, right: defaultCellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultCellSpacing
    }
    
}

// MARK: - Transition Animation -
extension FollowersViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

