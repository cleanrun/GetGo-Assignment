//
//  FilterModalPresentationController.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 23/02/23.
//

import UIKit

enum ModalScaleState {
    case presentation
    case interaction
}

final class FilterModalPresentationController: UIPresentationController {
    private let presentationHeight: CGFloat = UIScreen.main.bounds.height / 2
    private var direction: CGFloat = 0
    private var state: ModalScaleState = .interaction
    private lazy var dimmingView: UIView! = {
        guard let containerView else { return nil }
        
        let view = UIView(frame: containerView.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.75)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        return CGRect(x: 0,
                      y: presentationHeight,
                      width: containerView.bounds.width,
                      height: containerView.bounds.height - presentationHeight)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        presentedViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(_:))))
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view,
              let superview = view.superview,
              let presentedView,
              let containerView
        else {
            return
        }
        
        let location = sender.translation(in: superview)
        
        switch sender.state {
        case .began:
            presentedView.frame.size.height = presentationHeight
        case .changed:
            let velocity = sender.velocity(in: superview)
            guard location.y > 0 else { return }
            switch state {
            case .presentation:
                presentedView.frame.origin.y = location.y + presentationHeight
            case .interaction:
                presentedView.frame.origin.y = location.y + presentationHeight
            }
            direction = velocity.y
        case .ended:
            let maxPresentedY = containerView.frame.height - presentationHeight
            switch presentedView.frame.origin.y {
            case 0...maxPresentedY:
                changeScale(to: .interaction)
            default:
                presentedViewController.dismiss(animated: true)
                break
            }
        default:
            break
        }
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
    
    private func changeScale(to state: ModalScaleState) {
        guard let presentedView else { return }
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       animations: { [unowned self] in
            presentedView.frame = self.frameOfPresentedViewInContainerView
        }, completion: { [unowned self] _ in
            self.state = state
        })
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView,
              let coordinator = presentingViewController.transitionCoordinator
        else { return }
        
        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 1
        })
        
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
}
