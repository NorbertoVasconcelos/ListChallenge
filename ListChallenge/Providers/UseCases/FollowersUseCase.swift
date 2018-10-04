//
//  FollowersUseCase.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift

public protocol FollowersUseCaseProtocol {
    func followers() -> Observable<[User]>
    func followersFromSlug(_ slug: String) -> Observable<[User]>
}

final class FollowersUseCase: FollowersUseCaseProtocol {
    
    init() {
        
    }

    func followers() -> Observable<[User]> {
        return tonsserProvider.rx
            .request(.getFollowers())
            .mapObject(FollowersResponse.self)
            .asObservable()
            .map { $0.followers }
    }
    
    func followersFromSlug(_ slug: String) -> Observable<[User]> {
        return tonsserProvider.rx
        .request(.getFollowersFromCurrentSlug(slug))
        .mapObject(FollowersResponse.self)
        .asObservable()
        .map { $0.followers }
    }
}
