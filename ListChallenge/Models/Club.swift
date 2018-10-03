//
//  Club.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import ObjectMapper

struct Club: Mappable {
    var name: String = ""
    var logoURL: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        logoURL <- map["logo_url"]
    }
    
}
