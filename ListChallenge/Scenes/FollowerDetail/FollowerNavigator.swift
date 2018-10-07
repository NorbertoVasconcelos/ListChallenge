//
//  FollowerNavigator.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

protocol FollowerNavigator {
    func toFollowers()
}

class DefaultFollowerNavigator: FollowerNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, storyBoard: UIStoryboard) {
        self.storyBoard = storyBoard
        self.navigationController = navigationController
    }
    
    func toFollowers() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
