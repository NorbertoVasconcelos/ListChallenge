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
        let error: Driver<String>
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
        let errorTracker = ErrorTracker()
        let fetching = activityIndicator.asDriver()
        
        let trigger = input.trigger.do(onNext: {
            [weak self] in
            nearZone = 32.0
            self?.allFollowers = []
        })
        
//        self.useCase.followers("").scan([], accumulator: {
//            (list, newList) -> [User] in
//            return Array(list + newList)
//        })
        
        let followers = Driver.combineLatest(trigger, input.isNearBottom)
            .flatMap { _ -> Driver<[FollowerItemViewModel]> in
            
            let slug = self.allFollowers.last?.user.slug ?? ""
            
            return self.useCase.followers(slug)
                .observeOn(MainScheduler.asyncInstance)
                .trackError(errorTracker)
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
                    
                    print("# Followers: \(self!.allFollowers.count)")
                    return mutableList
            }
        }
        
        let error = errorTracker.map {
            error -> String in
            return error.localizedDescription
        }
        
        let selectedFollower = input.selection
            .map { self.allFollowers[$0.item].user }
            .do(onNext: navigator.toDetail)
        
        return Output(fetching: fetching,
                      followers: followers,
                      selectedFollower: selectedFollower,
                      error: error)
    }
}
