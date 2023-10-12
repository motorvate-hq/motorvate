//
//  InquiryViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 6/12/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit
import SafariServices

private enum Constants {
    static let title = "Send Service Form"
    static let watchTutorialButtonSize: CGSize = CGSize(width: 185, height: 37)
    static let previewButtonSize: CGSize = CGSize(width: 185, height: 37)
    static let keyboardOffset: CGFloat = 25
    static let completeInquiryTitle = "Complete Inquiry Now"
    static let sendInquiryTitle = "Send Link to Customer"
}

final class InquiryViewController: UIViewController {
    
    // MARK: - UI Elements
    private let centerView = UIView()
    private let phoneLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Customers Phone Number:")
    private let phoneTextField = AppComponent.makeFormTextField(.phonePad, inputFormat: .phoneNumber)
    private let sendLinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.semiBold, ofSize: 16)
        label.text = "Allow customer to complete Inquiry"
        return label
    }()
    private let uiSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = true
        return uiSwitch
    }()
    private let sendLinkCommentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: "An automated  link will be sent to customers phone via text. You will recieve a notification once Inquiry is submitted.\n\nNote: Weblinks expire after 15 minutes and you must reply to your Inquiry first to enable Two-Way SMS.")
        attributedString.setFontForText(textForAttribute: "Note:", withFont: AppFont.archivo(.bold, ofSize: 13))
        attributedString.setFontForText(textForAttribute: "first", withFont: AppFont.archivo(.bold, ofSize: 13))
        label.attributedText = attributedString
        return label
    }()
    private let watchTutorialButton: PopupActionButton = {
        let button = PopupActionButton(style: .yellow)
        button.setTitle("Watch Demo (1 Min) 🎥", for: .normal)
        return button
    }()
    private let previewServiceFormButton: PopupActionButton = {
        let button = PopupActionButton(style: .gray)
        button.setTitle("Preview Service Form", for: .normal)
        return button
    }()
    private let completeInquiryButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle(Constants.sendInquiryTitle, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
        return button
    }()

    // MARK: - Variables
    weak var coordinatorDelegate: JobsCoordinatorDelegate?
    fileprivate let viewModel: JobsViewModel
    
    var isScheduleToken: Bool

    // MARK: - Lifecycle
    init(viewModel: JobsViewModel, isScheduleToken: Bool) {
        self.viewModel = viewModel
        self.isScheduleToken = isScheduleToken
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBackButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        registerNotifications()
    }
    
    @objc private func handleCompleteInquiry() {
        guard let phone = phoneTextField.textValueForFormat(.phoneNumber) else {
            BaseViewController.presentAlert(message: "Input a valid customer phone. e.g: +1 234 567 8940", from: self)
            return
        }
        viewModel.setCustomerInfo(nil, nil, nil, phone)
        guard viewModel.isValidPhoneNumber else {
            BaseViewController.presentAlert(message: "Input a valid customer phone. e.g: +1 234 567 8940", from: self)
            return
        }
        uiSwitch.isOn ? didPressSendLinkButton(with: phone) : didPressCreateButton()
    }
    
    @objc private func handleWatchTutorial() {
        AnalyticsManager.logEvent(.watchInquiryTutorial)
        present(VideoController(videoType: .automateInquiries), animated: true)
    }
    
    @objc private func handleSwitchValueChange() {
        let title = uiSwitch.isOn ? Constants.sendInquiryTitle : Constants.completeInquiryTitle
        completeInquiryButton.setTitle(title, for: .normal)
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func handlePreviewServiceForm() {
        guard let phone = phoneTextField.textValueForFormat(.phoneNumber) else {
            BaseViewController.presentAlert(message: "Input a valid customer phone. e.g: +1 234 567 8940", from: self)
            return
        }
        viewModel.setCustomerInfo(nil, nil, nil, phone)
        guard viewModel.isValidPhoneNumber else {
            BaseViewController.presentAlert(message: "Input a valid customer phone. e.g: +1 234 567 8940", from: self)
            return
        }
        
        self.setAsLoading(true)
        viewModel.getFormInfo(with: phone, isScheduleToken: isScheduleToken, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setAsLoading(false)
            
            switch result {
            case .success(let formInfo):
                guard
                    let key = formInfo.key,
                    let url = URL(string: "\(Environment.webURL)/?key=\(key)")
                else { return }
                
                strongSelf.present(SFSafariViewController(url: url), animated: true)
            case .failure(let error):
                BaseViewController.presentAlert(message: error.localizedDescription, okHandler: {
                    
                }, from: strongSelf)
            }
        })
    }
    
    // MARK: - UI Setup
    private func setup() {
        title = Constants.title
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        view.addSubview(centerView)
        centerView.addSubview(phoneLabel)
        centerView.addSubview(phoneTextField)
        centerView.addSubview(sendLinkLabel)
        uiSwitch.addTarget(self, action: #selector(handleSwitchValueChange), for: .valueChanged)
        centerView.addSubview(uiSwitch)
        centerView.addSubview(sendLinkCommentLabel)
        watchTutorialButton.addTarget(self, action: #selector(handleWatchTutorial), for: .touchUpInside)
        centerView.addSubview(watchTutorialButton)
        previewServiceFormButton.addTarget(self, action: #selector(handlePreviewServiceForm), for: .touchUpInside)
        centerView.addSubview(previewServiceFormButton)
        completeInquiryButton.addTarget(self, action: #selector(handleCompleteInquiry), for: .touchUpInside)
        centerView.addSubview(completeInquiryButton)
    }
    
    private func setupConstraints() {
        centerView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
        phoneLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        phoneTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneLabel.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
            make.height.equalTo(43)
        }
        sendLinkLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneTextField.snp.bottom).offset(36)
            make.left.equalToSuperview()
            make.right.equalTo(uiSwitch.snp.left).inset(-10)
        }
        uiSwitch.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(sendLinkLabel.snp.centerY)
            make.right.equalToSuperview()
        }
        sendLinkCommentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sendLinkLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.right.equalTo(sendLinkLabel.snp.right)
        }
        watchTutorialButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sendLinkCommentLabel.snp.bottom).offset(15)
            make.size.equalTo(Constants.watchTutorialButtonSize)
            make.right.equalToSuperview()
        }
        previewServiceFormButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(watchTutorialButton.snp.bottom).offset(15)
            make.size.equalTo(Constants.watchTutorialButtonSize)
            make.right.equalToSuperview()
        }
        completeInquiryButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(previewServiceFormButton.snp.bottom).offset(15)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setUpBackButton() {
        let backItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didPressCloseButton))
        navigationItem.rightBarButtonItem = backItem
    }
}

// MARK: fileprivate
fileprivate extension InquiryViewController {
    func didPressCreateButton() {
        coordinatorDelegate?.showNewDropoffView(viewModel, shouldPush: true)
    }

    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func didPressCloseButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardTop = view.convert(keyboardFrame.cgRectValue, from: nil).minY
        let centerViewBottom = centerView.frame.maxY
        
        if centerViewBottom > keyboardTop {
            let offset = centerViewBottom - keyboardTop + Constants.keyboardOffset
            centerView.transform = .init(translationX: 0, y: -offset)
        }
    }

    @objc func keyboardWillHide() {
        centerView.transform = .init(translationX: 0, y: 0)
    }
}

// MARK: - ContactInfoViewDelegate
extension InquiryViewController: ContactInformationViewDelegate {
    func didPressSendLinkButton(with phoneNumber: String) {
        self.setAsLoading(true)
        viewModel.sendLinkInfo(with: phoneNumber, isScheduleToken: isScheduleToken, completion: { [weak self] isSuccess in
            guard let strongSelf = self else { return }
            strongSelf.setAsLoading(false)
            let message = isSuccess ? "Success. Form link sent." : "Unable to process request at this time. Please try again later"
            BaseViewController.presentAlert(message: message, okHandler: {
                isSuccess ? strongSelf.didPressCloseButton() : nil
            }, from: strongSelf)
        })
    }
}
