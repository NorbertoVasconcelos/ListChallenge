//
//  FollowersViewMolde.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 02/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowersViewModel: ViewModelType {
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let followers: Driver<[FollowerItemViewModel]>
        let selectedFollower: Driver<User>
    }
    
    var navigator: FollowersNavigator
    var useCase: FollowersUseCase
    
    init(useCase: FollowersUseCase, navigator: FollowersNavigator) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let followers = input.trigger.flatMapLatest { _ in
            return self.useCase.followers()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
                .map { $0.map { FollowerItemViewModel(with: $0) } }
        }
        
        let fetching = activityIndicator.asDriver()
        
        let selectedFollower = input.selection
            .withLatestFrom(followers) { (indexPath, followers) -> User in
                return followers[indexPath.row].user
            }
            .do(onNext: navigator.toDetail)
                
        return Output(fetching: fetching,
                      followers: followers,
                      selectedFollower: selectedFollower)
    }
}
