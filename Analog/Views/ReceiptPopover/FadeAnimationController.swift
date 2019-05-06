//
//  FadeAnimationController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import UIKit

public class FadeTransition: NSObject, UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutAnimationController()
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimationController()
    }
}

private class FadeInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let overlay: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        snapshot.frame = CGRect.zero
        snapshot.center = fromVC.view.center
        snapshot.alpha = 0

        containerView.addSubview(overlay)
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        toVC.view.frame = finalFrame
        overlay.frame = finalFrame

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.2, options: [], animations: {
            snapshot.alpha = 1
            self.overlay.alpha = 0.5
            snapshot.frame = finalFrame
        }, completion: { _ in
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

private class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {
            containerView.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
