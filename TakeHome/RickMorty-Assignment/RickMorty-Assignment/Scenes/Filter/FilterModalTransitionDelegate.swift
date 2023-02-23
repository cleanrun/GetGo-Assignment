//
//  FilterModalTransitionDelegate.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 23/02/23.
//

import UIKit

final class FilterModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private var interactiveDismiss: Bool
    
    init(from presented: UIViewController, to presenting: UIViewController, isInteractive: Bool = true) {
        interactiveDismiss = isInteractive
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FilterModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        nil
    }
}
