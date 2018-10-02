//
//  User.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 02/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation

typealias JSONData = [String: Any]

struct User {
    var firstName: String
    var lastName: String
    var profilePicture: String?
    var role: String?
    var countryID: Int?
//    var club: Club?
//    var primaryPosition: PrimaryPosition?
    var isVerified: Bool
    var gender: String?
    
    init(jsonData: JSONData) {
        self.firstName = jsonData["firstname"] as? String ?? ""
        self.lastName = jsonData["lastname"] as? String ?? ""
        self.profilePicture = jsonData["profile_picture"] as? String ?? ""
        self.role = jsonData["role"] as? String ?? ""
        self.gender = jsonData["gender"] as? String ?? ""
        self.countryID = jsonData["country_id"] as? Int ?? -1
        self.isVerified = jsonData["is_verified"] as? Bool ?? false
    }
    
}
