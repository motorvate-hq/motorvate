//
//  UIViewController+Extensions.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-08-01.
//  Copyright © 2020 motorvate. All rights reserved.
//
import UIKit

extension UIViewController {

    /**
     A generic function for presenting *UIAlertController*s from any controller that
     inherits from UIViewController. With one option, that is "Okay".
     - Parameters:
        - title: Title for the *UIAlertController*.
        - message: Message for the *UIAlertController*.
        - handler: Completion function for the action(in this case with the only option of "Okay").
     ### How to use: ###
     ````
     let myViewController = UIViewController()
     myViewController.presentAlert(title: "myTitle", message: "myMessage")
     myViewController.presentAlert(title: "myTitle", message: "myMessage") {
        ...
        print("This rocks!")
     }
     ```
     */
    func presentAlert(
        title: String? = nil,
        message: String?,
        handler: (() -> Void)? = nil
    ) {
        let errorPopupControllervc = ErrorPopupController(title: title, message: message, handler: handler)
        present(errorPopupControllervc, animated: false)
    }

    /**
    Easy way to show ViewControllers as loading with an Activity Indicator in the center of the view.
    - Parameters:
       - asLoading: True if it should load, False if it should not..
    ### How to use: ###
    ````
    let myViewController = UIViewController()
    myViewController.setAsLoading(true)
    myViewController.setAsLoading(false)
    ```
    */
    func setAsLoading(_ asLoading: Bool) {
        if asLoading {
            overlayContainerView.displayAnimatedActivityIndicatorView()
        } else {
            overlayContainerView.hideAnimatedActivityIndicatorView()
        }
    }
}

private extension UIViewController {
    private var overlayContainerView: UIView {
        if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }
}

extension UIView {
    private enum _Constants {
        static let overlayViewTag: Int = -111
        static let activityIndicatorViewTag: Int = -222
        static let animationDuraion: TimeInterval = 0.2
    }

    private var activityIndicatorView: UIActivityIndicatorView {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = _Constants.activityIndicatorViewTag
        view.color = .white
        return view
    }

    private var overlayView: UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        view.tag = _Constants.overlayViewTag
        return view
    }

    private func setActivityIndicatorView() {
        guard !isDisplayingActivityIndicatorOverlay() else { return }
        let overlayView: UIView = self.overlayView
        let activityIndicatorView: UIActivityIndicatorView = self.activityIndicatorView

        // add subviews
        addSubview(overlayView)
        addSubview(activityIndicatorView)

        // add overlay constraints
        overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        // add indicator constraints
        activityIndicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true

        // animate indicator
        activityIndicatorView.startAnimating()
    }

    private func removeActivityIndicatorView() {
        guard let overlayView: UIView = getOverlayView(),
              let activityIndicator: UIActivityIndicatorView = getActivityIndicatorView() else { return }

        UIView.animate(withDuration: _Constants.animationDuraion, animations: {
            overlayView.alpha = 0.0
            activityIndicator.stopAnimating()
        }, completion: { _ in
            activityIndicator.removeFromSuperview()
            overlayView.removeFromSuperview()
        })
    }

    func displayAnimatedActivityIndicatorView() {
        setActivityIndicatorView()
    }

    func hideAnimatedActivityIndicatorView() {
        removeActivityIndicatorView()
    }

    private func isDisplayingActivityIndicatorOverlay() -> Bool {
        getActivityIndicatorView() != nil && getOverlayView() != nil
    }

    private func getActivityIndicatorView() -> UIActivityIndicatorView? {
        viewWithTag(_Constants.activityIndicatorViewTag) as? UIActivityIndicatorView
    }

    private func getOverlayView() -> UIView? {
        viewWithTag(_Constants.overlayViewTag)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func pop(animated: Bool = true) {
        guard
            let nc = self.navigationController,
            let index = nc.viewControllers.firstIndex(of: self)
        else { return }
        
        nc.popToViewController(nc.viewControllers[index > 0 ? index - 1 : 0], animated: animated)
    }
    
    func add(childViewController vc: UIViewController, to containerView: UIView? = nil) {
        let view = (containerView ?? self.view)!
        
        vc.willMove(toParent: self)
        self.addChild(vc)
        
        view.addSubview(vc.view)
        
        // Fit to left, right, and to edges of parent. It will automatically grow to bottom
        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        vc.didMove(toParent: self)
    }
    
    func add(child: UIViewController, to containerView: UIView) {
        self.addChild(child)
        containerView.addSubview(child.view)
        child.view.frame = containerView.bounds
        child.didMove(toParent: self)
    }
}
