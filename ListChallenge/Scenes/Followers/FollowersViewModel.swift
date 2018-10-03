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
    
    init(navigator: FollowersNavigator) {
        self.navigator = navigator
    }
    
    func getFollowers() -> Single<FollowersResponse> {
        return tonsserProvider.rx
            .request(.getFollowers())
            .mapObject(FollowersResponse.self)
        
//            .subscribe { event in
//                switch event {
//                case .success(let response):
//                    self.followers = response.followers
//                    print("SUCCESS!")
//                    break
//                case .error(let error):
//                    print(error)
//                    print("ERROR!")
//                }
//        }
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let followers = input.trigger.flatMapLatest { _ in
            return self.getFollowers()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
                .map { $0.followers.map { FollowerItemViewModel(with: $0) } }
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
