//
//  Created by Bojan on 2.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit

protocol SlideUpViewControllerDelegate: AnyObject {
    func canDismissViewController() -> Bool
}

class SlideUpViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!

    weak var viewController: UIViewController?
    
    weak var delegate: SlideUpViewControllerDelegate?

    static func instantiate(with viewController: UIViewController, size: CGSize) -> SlideUpViewController {
        guard let vc = Bundle(for: SlideUpViewController.self).loadNibNamed("SlideUpViewController", owner: self, options: nil)?[0] as? SlideUpViewController
        else {
            return SlideUpViewController()
        }
        vc.viewController = viewController
        vc.add(child: viewController, to: vc.containerView)
        vc.containerHeightConstraint.constant = size.height

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        animatePresentation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewController?.view.frame.size.width = self.containerView.frame.size.width
    }

    private func setupViews() {
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.size.height + 50)
    }

    private func setupKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue

        if notification.name == UIResponder.keyboardWillHideNotification {
            UIView.animate(withDuration: 0.33, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent], animations: {
                self.containerBottomConstraint.constant = self.containerLeadingConstraint.constant
                self.view.layoutIfNeeded()
            })
        } else if containerBottomConstraint.constant != keyboardScreenEndFrame.height + self.containerLeadingConstraint.constant {
            UIView.animate(withDuration: 0.33, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent], animations: {
                self.containerBottomConstraint.constant = keyboardScreenEndFrame.height + self.containerLeadingConstraint.constant
                self.view.layoutIfNeeded()
            })
        }
    }

    private func animatePresentation() {
        UIView.animate(withDuration: 0.33, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent], animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }

    func dismissWithAnimation(_ callback: @escaping (() -> Void) = {}) {
        if self.delegate?.canDismissViewController() == false {
            return
        }
        
        self.view.endEditing(true)

        UIView.animate(withDuration: 0.33, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent], animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.size.height + 50)
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {
                callback()
            })
        }
    }
}

extension SlideUpViewController {
    @IBAction func actionHide(_ sender: AnyObject) {
        self.dismissWithAnimation()
    }
}
