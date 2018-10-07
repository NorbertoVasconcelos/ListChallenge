//
//  PopAnimator.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 04/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public let CustomAnimatorTag = 99

    var duration : TimeInterval
    var isPresenting : Bool
    var originFrame : CGRect
    var image : UIImage
    
    init(duration : TimeInterval, isPresenting : Bool, originFrame : CGRect, image : UIImage) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.originFrame = originFrame
        self.image = image
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)

        let detailView = isPresenting ? toView : fromView

        guard let userImage = detailView.viewWithTag(CustomAnimatorTag) as? UIImageView else { return }
        userImage.image = image
        userImage.alpha = 0

        let transitionImageView = UIImageView(frame: isPresenting ? originFrame : userImage.frame)
        transitionImageView.image = image
        transitionImageView.clipsToBounds = true
        transitionImageView.layer.cornerRadius = 8

        container.addSubview(transitionImageView)

        toView.frame = isPresenting ?  CGRect(x: 0, y: fromView.frame.height, width: toView.frame.width, height: toView.frame.height) : toView.frame
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()

        UIView.animate(withDuration: duration, animations: {
            transitionImageView.frame = self.isPresenting ? userImage.frame : self.originFrame
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: 0, y: toView.frame.height, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            userImage.alpha = 1
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
