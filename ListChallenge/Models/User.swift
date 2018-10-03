//
//  User.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 02/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import ObjectMapper

typealias JSONData = [String: Any]

struct User: Mappable {
    var firstName: String = ""
    var lastName: String = ""
    var profilePicture: String?
    var role: String?
    var countryID: Int?
    var club: Club?
    var isVerified: Bool = false
    var gender: String?

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        firstName <- map["firstname"]
        lastName <- map["lastname"]
        profilePicture <- map["profile_picture"]
        role <- map["role"]
        countryID <- map["country_id"]
        club <- map["club"]
        isVerified <- map["is_verified"]
        gender <- map["gender"]
    }
    
}
