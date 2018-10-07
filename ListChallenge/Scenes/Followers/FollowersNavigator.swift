//
//  FollowersNavigator.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 02/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

protocol FollowersNavigator {
    func toFollowers()
    func toDetail(_ user: User)
}

class DefaultFollowersNavigator: FollowersNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let useCase: FollowersUseCase
    
    init(navigationController: UINavigationController, storyBoard: UIStoryboard, useCase: FollowersUseCase) {
        self.storyBoard = storyBoard
        self.navigationController = navigationController
        self.useCase = useCase
    }
    
    func toFollowers() {
        let vc = storyBoard.instantiateViewController(ofType: FollowersViewController.self)
        vc.viewModel = FollowersViewModel(useCase: useCase, navigator: self as FollowersNavigator)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toDetail(_ user: User) {
        let vc = storyBoard.instantiateViewController(ofType: FollowerDetailViewController.self)
        vc.viewModel = FollowerDetailViewModel(navigator: DefaultFollowerNavigator(navigationController: navigationController, storyBoard: storyBoard), user: user)
        if let followersVC = navigationController.topViewController as? FollowersViewController {
            vc.transitioningDelegate = followersVC
        }
        navigationController.present(vc, animated: true, completion: nil)
    }
}
