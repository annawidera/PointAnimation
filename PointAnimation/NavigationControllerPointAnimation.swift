//
//  NavigationControllerPointAnimation.swift
//  PointAnimation
//
//  Created by Ania Widera on 03.11.2016.
//  Copyright © 2016 Ania Widera. All rights reserved.
//

import UIKit

class NavigationControllerPointAnimation: NSObject, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationController: UINavigationController?
    var interactionController: UIPercentDrivenInteractiveTransition?

    override func awakeFromNib() {
        super.awakeFromNib()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.navigationController!.view.addGestureRecognizer(panGesture)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PointTransitionAnimator()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
    
    @IBAction func panned(gestureRecognizer: UIPanGestureRecognizer) {
        
        func distanceSquare(x: CGFloat, y: CGFloat) -> CGFloat {
            return (x*x + y*y)
        }
        
        switch gestureRecognizer.state {
        case .began:
                self.interactionController = UIPercentDrivenInteractiveTransition()
                if self.navigationController!.viewControllers.count > 1 { // need to pop the second view
                    self.navigationController!.popViewController(animated: true)
                } else {
                    self.navigationController!.topViewController?.performSegue(withIdentifier: "push", sender: nil)
                }
                break
            
        case .changed:
            let translation = gestureRecognizer.translation(in: self.navigationController!.view)
            
            if !(translation.x < 0 && translation.y > 0) {
                self.interactionController?.update(0)
                break;
            }
            let distance = ( translation: distanceSquare(x: translation.x, y: translation.y),
                             viewDiagonal: distanceSquare(x: self.navigationController!.view.bounds.width, y: self.navigationController!.view.bounds.width) )
       
            let completion = distance.translation/distance.viewDiagonal
            self.interactionController?.update(completion)
            
        case .ended:
            let velocity = gestureRecognizer.velocity(in: self.navigationController!.view)
            
            (velocity.x < 0 && velocity.y > 0) ? self.interactionController?.finish() : self.interactionController?.cancel()
            self.interactionController = nil
            
        default:
            self.interactionController?.cancel()
            self.interactionController = nil
        }
    }
}
