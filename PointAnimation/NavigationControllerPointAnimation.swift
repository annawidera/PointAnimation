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
            let completion = translation.x/self.navigationController!.view.bounds.width
            self.interactionController?.update(completion)
            
        case .ended:
            gestureRecognizer.velocity(in: self.navigationController!.view).x > 0 ? self.interactionController?.finish() : self.interactionController?.cancel()
            self.interactionController = nil
            
        default:
            self.interactionController?.cancel()
            self.interactionController = nil
        }
    }
}
