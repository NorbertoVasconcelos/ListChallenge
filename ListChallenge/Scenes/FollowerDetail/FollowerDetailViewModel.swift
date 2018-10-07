//
//  FollowerDetailViewModel.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowerDetailViewModel: ViewModelType {
    struct Input {
        let trigger: Driver<Void>
        let close: Driver<Void>
    }
    struct Output {
        
    }
    
    var navigator: FollowerNavigator
    
    init(navigator: FollowerNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        
        
        return Output()
    }
}
