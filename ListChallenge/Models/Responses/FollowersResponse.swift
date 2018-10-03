//
//  FollowersResponse.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import ObjectMapper

struct FollowersResponse: Mappable {
    var followers: [User] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        followers <- map["response"]
    }
}
