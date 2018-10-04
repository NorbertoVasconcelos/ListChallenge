//
//  Application.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

final class Application {
    static let shared = Application()
    
    private let useCaseProvider: FollowersUseCase
    
    private init() {
        useCaseProvider = FollowersUseCase()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        let navigator = DefaultFollowersNavigator(navigationController: navigationController,
                                                  storyBoard: storyboard,
                                                  useCase: useCaseProvider)
        
        window.rootViewController = navigationController
        
        navigator.toFollowers()
    }
}
