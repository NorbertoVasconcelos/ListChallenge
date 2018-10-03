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
    func toDetail()
}

class DefaultFollowersNavitor: FollowersNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, storyBoard: UIStoryboard) {
        self.storyBoard = storyBoard
        self.navigationController = navigationController
    }
    
    func toDetail() {
        let vc = storyBoard.instantiateViewController(ofType: FollowerDetailViewController.self)
        navigationController.pushViewController(vc, animated: true)
    }
}
