//
//  PrimaryPosition.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 04/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import ObjectMapper


struct PrimaryPosition: Mappable {
    var name: String = ""
    var abbreviation: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        abbreviation <- map["abbreviation"]
    }
    
}
