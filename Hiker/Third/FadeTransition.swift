//
//  FadeTransition
//  Hiker
//
//  Created by 张驰 on 2019/9/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit


open class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionDuration: TimeInterval = 1
    var startingAlpha: CGFloat = 0.5

    public convenience init(transitionDuration: TimeInterval, startingAlpha: CGFloat){
        self.init()
        self.transitionDuration = transitionDuration
        self.startingAlpha = startingAlpha
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        toView.alpha   = startingAlpha
        fromView.alpha = 0.8
        
        toView.frame = containerView.frame
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            toView.alpha   = 1.0
            fromView.alpha = 0.0 
            }, completion: { _ in
                fromView.alpha = 1.0
                transitionContext.completeTransition(true)
        })
    }
}
