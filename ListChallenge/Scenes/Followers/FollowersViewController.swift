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

class FollowersViewController: UIViewController {

    @IBOutlet weak var colView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private let defafultCellHeight: CGFloat = 80
    var viewModel: FollowersViewModel = FollowersViewModel(navigator: FollowersNavigator())
    var followers: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
    }
    
    private func configureCollectionView() {
        colView.delegate = self
        colView.refreshControl = UIRefreshControl()
        colView.register(UINib(nibName: FollowerCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
    }
    
    // MARK: - Bind -
    private func bindViewModel() {
//        guard let viewModel = viewModel else {
//            return
//        }
        
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .asDriverOnErrorJustComplete()
            .mapToVoid()
        
        let pull = colView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
                
        let input = FollowersViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                             selection: colView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)

        output.followers.drive(colView.rx.items(cellIdentifier: FollowerCollectionViewCell.reuseID, cellType: FollowerCollectionViewCell.self)) {
            index, model, cell in
            cell.bindViewModel(model)
        }
        .disposed(by: disposeBag)
        
        output.fetching
            .drive(colView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

// MARK: - FlowLayout -
extension FollowersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: defafultCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    
}
