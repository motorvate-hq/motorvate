//
//  WebController.swift
//  Motorvate
//
//  Created by Nikita Benin on 13.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

import WebKit

private struct Constants {
    static let refreshUrl = "https://example.com/reauth"
    static let returnUrl = "https://example.com/return"
}

protocol WebControllerDelegate: AnyObject {
    func didDismiss()
}

class WebController: UIViewController {
    
    // MARK: - UI Elements
    private let webView = WKWebView()
    
    // MARK: - Variables
    weak var delegate: WebControllerDelegate?
    private var url: URL?
    
    override func loadView() {
        
        view = webView
        setup()
    }
    
    // MARK: - Lifecycle
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        
        if let url = url {
            let reuqest = URLRequest(url: url)
            webView.load(reuqest)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString else { return }
        switch urlString {
        case Constants.refreshUrl, Constants.returnUrl:
            dismiss(animated: true, completion: { [weak self] in
                self?.delegate?.didDismiss()
            })
        default:
            break
        }
    }
}
