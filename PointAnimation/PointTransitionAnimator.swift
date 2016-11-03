//
//  PointTransitionAnimator.swift
//  PointAnimation
//
//  Created by Ania Widera on 03.11.2016.
//  Copyright © 2016 Ania Widera. All rights reserved.
//

import UIKit
struct CircleMaskFinalHelper {
    var extremePoint : CGPoint {
        didSet {
            calcRadius()
        }
    }
    var _radius: CGFloat?
    
    init(with point: CGPoint) {
        extremePoint = point
        calcRadius()
    }
    
    mutating func calcRadius() {
        self._radius = CGFloat(sqrt(Double(extremePoint.x * extremePoint.x) + Double(extremePoint.y * extremePoint.y)))
    }
    
    func radius() -> CGFloat {
        return self._radius ?? 200.0
    }
}


class PointTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from) as! ViewController
        let toViewController = transitionContext.viewController(forKey: .to) as! ViewController
        let button = fromViewController.button
        
        containerView.addSubview(toViewController.view)
        
        let circlesMaskFinalHelper = CircleMaskFinalHelper(with: CGPoint(x: button?.center.x ?? 0, y: ((button?.center.y ?? 0) - toViewController.view.bounds.height)))
        let circleMask = (
            initial: UIBezierPath(ovalIn: button?.frame ?? CGRect(x: 0, y: 0, width: 40, height: 40)),
            final: UIBezierPath(ovalIn: (button?.frame.insetBy(dx: -circlesMaskFinalHelper.radius(), dy: -circlesMaskFinalHelper.radius()))!)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMask.final.cgPath
        toViewController.view.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMask.initial.cgPath
        maskLayerAnimation.toValue = circleMask.final.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
        self.transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
    }
}
