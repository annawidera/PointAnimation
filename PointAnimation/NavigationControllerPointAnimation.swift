//
//  NavigationControllerPointAnimation.swift
//  PointAnimation
//
//  Created by Ania Widera on 03.11.2016.
//  Copyright © 2016 Ania Widera. All rights reserved.
//

import UIKit

class NavigationControllerPointAnimation: NSObject, UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PointTransitionAnimator()
    }
}
