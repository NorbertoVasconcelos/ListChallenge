//
//  Observable+Ext.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
}

public var nearZone: CGFloat = 32.0
extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 500.0) -> Bool {
        guard self.contentSize.height > nearZone else {
            return false
        }
        let scrolled = self.contentOffset.y + self.frame.size.height + edgeOffset
        let isNear = scrolled > self.contentSize.height
        if isNear {
            nearZone = scrolled + edgeOffset
        }
        return isNear
    }
}
