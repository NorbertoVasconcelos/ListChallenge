//
//  FollowerItemViewModel.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation

final class FollowerItemViewModel   {
    let title:String
    let subtitle : String
    let user: User
    
    init (with user: User) {
        self.user = user
        self.title = ""
        self.subtitle = ""
    }
}
