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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
                if let cell = self.colView.cellForItem(at: indexPath) as? FollowerCollectionViewCell {
                    self.transition = PopAnimator(duration: 0.3, isPresenting: true, originFrame: self.selectedFrame, image: cell.imgUser.image ?? UIImage(named: "default_user")!)
                }
            })
            .asDriverOnErrorJustComplete()
        
        let isNearBottom = colView.rx
            .contentOffset
            .flatMap { _ in
                self.colView.isNearBottomEdge() ? Observable.just(()) : Observable.empty()
            }
            .asDriverOnErrorJustComplete()
            .throttle(5)
        
        let input = FollowersViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                             selection: itemSelected,
                                             isNearBottom: isNearBottom)
        
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
    
    private func shouldLoadMore(scrollView: UIScrollView) -> Bool {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        return offsetY > contentHeight - scrollView.frame.size.height
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

extension FollowersViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}
