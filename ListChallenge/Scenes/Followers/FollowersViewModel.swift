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
        let isNearBottom: Driver<Void>
    }
    struct Output {
        let fetching: Driver<Bool>
        let followers: Driver<[FollowerItemViewModel]>
        let selectedFollower: Driver<User>
    }
    
    var navigator: FollowersNavigator
    var useCase: FollowersUseCase
    var allFollowers: [FollowerItemViewModel] = []
    
    init(useCase: FollowersUseCase, navigator: FollowersNavigator) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let fetching = activityIndicator.asDriver()
        
        let followers = Driver
            .combineLatest(input.trigger, input.isNearBottom)
            .flatMap { (_, _) -> Driver<[FollowerItemViewModel]> in
    
            let slug = self.allFollowers.last?.user.slug ?? ""

                return self.useCase.followers(slug)
                    .observeOn(MainScheduler.asyncInstance)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .map { $0.map { FollowerItemViewModel(with: $0) } }
                    .map { [weak self] items in
                        guard self != nil else {
                            return []
                        }
                        var mutableList: [FollowerItemViewModel] = []
                        mutableList.append(contentsOf: self!.allFollowers)
                        mutableList.append(contentsOf: items)
                        self?.allFollowers = mutableList
                        return mutableList
                    }
        }
        
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
