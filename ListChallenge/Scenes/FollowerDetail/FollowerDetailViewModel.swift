//
//  FollowerDetailViewModel.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowerDetailViewModel: ViewModelType {
    struct Input {
        var trigger: Driver<Void>
        var close: Driver<Void>
    }
    struct Output {
        var follower: Driver<User>
        var close: Driver<Void>
    }
    
    var navigator: FollowerNavigator
    var user: User
    
    init(navigator: FollowerNavigator, user: User) {
        self.navigator = navigator
        self.user = user
    }
    
    func transform(input: Input) -> Output {
        let follower = input
            .trigger
            .map { [unowned self] in
                return self.user
            }
            .asDriver()
        
        let close = input.close.do(onNext: {self.navigator.toFollowers()})
        return Output(follower: follower, close: close)
    }
}
