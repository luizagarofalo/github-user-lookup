//
//  TransitionViewController.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 11/27/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
    }

    public func animationController(forPresented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }

    public func animationController(forDismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
}
