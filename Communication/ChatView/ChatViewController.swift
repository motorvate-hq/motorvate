//
//  ChatViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 9/6/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import MessageKit
import UIKit

final class ChatViewController: MessagesViewController {

    // MARK: - UI Elements
    private let chatNavigationView = ChatNavigationView()
    private let chatJobSelectorView = ChatJobSelectorView()
    private let chatAttachmentsView = ChatAttachmentsView()
    private let sendButton = ChatSendButton()
    
    // MARK: - Variables
    var shouldSendInvoice: Bool = false
    var messages: [Message] = []
    private let viewModel: ChatViewModel

    // MARK: - Lifecycle
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()

        viewModel.didReceiveAction = { [weak self] action in
            self?.handle(action)
        }

        viewModel.viewDidLoad()
        NotificationRepository.shared.addListener(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hidesBottomBarWhenPushed = true
        messagesCollectionView.scrollToLastItem(animated: true)
        viewModel.removeNotificationsBadge()
    }

    private func handle(_ action: ChatAction) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            switch action {
            case .reloadData:
                strongSelf.chatNavigationView.setTitles(
                    title: strongSelf.viewModel.customerNameText,
                    subtitle: strongSelf.viewModel.customerCarText,
                    showDropDown: strongSelf.viewModel.showDropDown
                )
                strongSelf.messages = strongSelf.viewModel.messages
                strongSelf.messagesCollectionView.reloadData()
                strongSelf.messagesCollectionView.scrollToLastItem(animated: true)
                strongSelf.chatJobSelectorView.configure(
                    with: ChatJobSelectorViewModel(chatHistory: strongSelf.viewModel.chatHistory)
                )
                strongSelf.chatJobSelectorView.didSelectCellAction = { [weak self] selectedCell in
                    self?.didSwitchCurrentJob(selectedCell: selectedCell)
                }
                
                if strongSelf.shouldSendInvoice {
                    strongSelf.shouldSendInvoice = false
                    guard let job = strongSelf.viewModel.getCurrentJob() else { return }
                    let popupViewModel = DepositEstimatePopupViewModel(
                        job: job,
                        chatHistory: strongSelf.viewModel.chatHistory
                    )
                    strongSelf.showDepositEstimate(popupViewModel: popupViewModel)
                }
            case .setLoadingMode(let shouldLoad):
                strongSelf.setAsLoading(shouldLoad)
            case .showAlert(let shouldClose, let error):
                strongSelf.presentAlert(title: "Error", message: error.localizedDescription, handler: {
                    if shouldClose {
                        strongSelf.navigationController?.popViewController(animated: true)
                    }
                })
            case .showConnectBank:
                strongSelf.showConnectBank()
            case .showEnableNotifications:
                strongSelf.showEnableNotifcationsPopup()
            }
        }
    }
    
    private func showConnectBank() {
        if presentedViewController == nil {
            let connectBankPopupController = ConnectBankPopupController()
            connectBankPopupController.delegate = self
            present(connectBankPopupController, animated: false, completion: nil)
        }
    }
    
    private func bind() {
        viewModel.jobStatus.bind(listener: { [weak self] status in
            self?.chatNavigationView.setJobStatus(jobStatus: status)
            self?.hideShowChatAttachments(jobStatus: status)
        })
    }
    
    private func hideShowChatAttachments(jobStatus: Job.Status) {
        switch jobStatus {
        case .inqueue, .inProgress:
            chatAttachmentsView.isHidden = false
            if let job = viewModel.getCurrentJob() {
                if job.inquiryPaidDetail != nil {
                    chatAttachmentsView.setView(type: .paidJob)
                    return
                }
            }
            chatAttachmentsView.setView(type: .job)
        case .completed:
            chatAttachmentsView.isHidden = true
        case .none:
            chatAttachmentsView.isHidden = false
            chatAttachmentsView.setView(type: .inquiry)
        }
    }
    
    private func didSwitchCurrentJob(selectedCell: ChatJobSelectorCellModel) {
        let isInquiry = selectedCell.isInquiry
        let id = selectedCell.id
        
        viewModel.updateCurrentJobInquiry(
            inquiryId: isInquiry ? id : nil,
            jobId: isInquiry ? nil : id
        )
        
        chatNavigationView.setSubtitle(subtitle: viewModel.customerCarText)
        chatJobSelectorView.isHidden = true
    }
    
    private func presentJobDetails(depositFeeType: DepositFeeType) {
        guard let job = viewModel.getCurrentJob() else { return }
        let jobDetailsViewController = ServiceDetailsViewController(
            viewModel:
                JobDetailsViewModel(
                    job: job,
                    depositFeeType: depositFeeType
                ), excludingDeposit: false
        )
        navigationController?.pushViewController(jobDetailsViewController, animated: true)
    }
    
    private func presentInquiryDetails(type: DepositEstimateType, depositFeeType: DepositFeeType, excludingDeposit: Bool) {
        guard let inquiry = viewModel.getCurrentInquiry() else { return }
        let jobDetailsViewController = ServiceDetailsViewController(
            viewModel: InquiryDetailsViewModel(
                inquiry: inquiry,
                depositPercent: type.percent,
                depositFeeType: depositFeeType
            ), excludingDeposit: excludingDeposit
        )
        navigationController?.pushViewController(jobDetailsViewController, animated: true)
    }
}

extension ChatViewController {
    
    // MARK: - UI Setup
    private func configure() {
        messages = viewModel.messages
        
        configureNavigationView()
        configureMessageCollectionView()
        configureMessageInputBar()
        configureSendButton()
        setView()
        setupConstraints()
    }
    
    private func configureNavigationView() {
        chatNavigationView.setTitles(
            title: viewModel.customerNameText,
            subtitle: viewModel.customerCarText,
            showDropDown: viewModel.showDropDown
        )
        chatNavigationView.delegate = self
        navigationItem.hidesBackButton = true
        navigationItem.titleView = chatNavigationView
    }

    private func configureMessageCollectionView() {
        messagesCollectionView.register(MessageDateReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        guard let flowLayout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        flowLayout.setMessageIncomingAvatarSize(.zero)
        flowLayout.setMessageOutgoingAvatarSize(.zero)
        flowLayout.textMessageSizeCalculator.incomingMessageLabelInsets = UIEdgeInsets(top: 14, left: 22, bottom: 14, right: 22)
        flowLayout.textMessageSizeCalculator.outgoingMessageLabelInsets = UIEdgeInsets(top: 14, left: 22, bottom: 14, right: 22)
    }

    private func configureMessageInputBar() {
        messageInputBar = ChatInputBarView()
        messageInputBar.topStackView.addArrangedSubview(chatAttachmentsView)
    }
    
    private func configureSendButton() {
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.setSize(CGSize(width: 49, height: 49), animated: false)
    }
    
    private func setView() {
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        messageInputBar.addSubview(sendButton)
        chatAttachmentsView.delegate = self
        view.addSubview(chatJobSelectorView)
    }
    
    private func setupConstraints() {
        sendButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(messageInputBar.sendButton.snp.bottom)
            make.right.equalToSuperview().inset(25)
            make.size.equalTo(ChatSendButton.size)
        }
        chatJobSelectorView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        chatAttachmentsView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(80)
        }
    }
    
    // MARK: - Handlers
    @objc private func handleSendMessage() {
        if let textMessage = messageInputBar.inputTextView.text {
            if textMessage.replacingOccurrences(of: " ", with: "") != "" {
                messageInputBar.inputTextView.text = ""
                viewModel.sendMessage(text: textMessage)
            }
        }
    }
    
    func showEnableNotifcationsPopup() {
        let alertController = UIAlertController(title: "Enable notifications", message: "Please enable notifications in Settings to get notified when a customer sends you a message or confirms job details.", preferredStyle: .alert)
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(.init(title: "Enable", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }))
        present(alertController, animated: true)
    }
    
    // MARK: - Helpers
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].user.senderId == messages[indexPath.section - 1].user.senderId
    }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return viewModel.appUserSender
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
}

// MARK: - ChatNavigationViewDelegate
extension ChatViewController: ChatNavigationViewDelegate {
    func handleSubtitle() {
        messageInputBar.inputTextView.resignFirstResponder()
        chatJobSelectorView.isHidden.toggle()
    }
    
    func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleStatus() {
        guard viewModel.jobStatus.value != .completed else {
            print("Updating status for completed Job is not allowed.")
            return
        }
        
        let jobStatusController = JobStatusPopupController(status: viewModel.jobStatus.value) { [weak self] status in
            self?.viewModel.updateJobStatus(status: status)
        }
        present(jobStatusController, animated: false)
    }
}

// MARK: - ChatAttachmentsViewDelegate
extension ChatViewController: ChatAttachmentsViewDelegate {
    func didSelect(model: ChatAttachmentsViewModel) {
        switch model {
        case .invoice:
            guard let job = viewModel.getCurrentJob() else { return }
            let popupViewModel = DepositEstimatePopupViewModel(
                job: job,
                chatHistory: viewModel.chatHistory
            )
            showDepositEstimate(popupViewModel: popupViewModel)
        case .serviceItem:
            if navigationController?.topViewController == self {
                presentJobDetails(depositFeeType: .exclude)
            }
        case .depositEstimate(let excludingDeposit):
            guard let inquiry = viewModel.getCurrentInquiry() else { return }
            let popupViewModel = DepositEstimatePopupViewModel(inquiry: inquiry, excludingDeposit: excludingDeposit)
            showDepositEstimate(popupViewModel: popupViewModel, excludingDeposit: excludingDeposit)
        case .onboardVehicle:
            guard let inquiry = viewModel.getCurrentInquiry() else { return }
            showOnboarding(inquiry: inquiry)
        }
    }
    
    func showDepositEstimate(popupViewModel: DepositEstimatePopupViewModel, excludingDeposit: Bool = false) {
        guard !excludingDeposit else {
            let vc = DepositEstimatePopupController(viewModel: popupViewModel, delegate: self)
            self.present(vc, animated: false)
            
            return
        }
        
        viewModel.hasConnectedBank { [weak self] in
            guard let strongSelf = self, strongSelf.presentingViewController == nil else { return }
            let vc = DepositEstimatePopupController(viewModel: popupViewModel, delegate: strongSelf)
            strongSelf.present(vc, animated: false)
        }
    }
    
    func showOnboarding(inquiry: Inquiry) {
        let viewModel = OnboardViewModel(JobService(), requestMeta: JobRequestMeta())
        viewModel.shouldShowCustomerInquiryView = false
        viewModel.setIquiryIdentifier(inquiry.id)
        viewModel.serviceDetail = inquiry.inquiryDetails
        let navController = UINavigationController(rootViewController: OnboardingViewController(viewModel))
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

extension ChatViewController: DepositEstimatePopupControllerDelegate {
    func handleEditDetails(serviceType: ServiceType, type: DepositEstimateType, fee: DepositFeeType) {
        switch serviceType {
        case .job:      presentJobDetails(depositFeeType: fee)
        case .inquiry(let excludingDeposit):  presentInquiryDetails(type: type, depositFeeType: fee, excludingDeposit: excludingDeposit)
        }
    }
    
    func sendLink(serviceType: ServiceType, type: DepositEstimateType, fee: DepositFeeType) {
        switch serviceType {
        case .job:      viewModel.sendInvoice(fee: fee)
        case .inquiry:  viewModel.sendEstimationLink(type: type, fee: fee)
        }
    }
}

// MARK: - NotificationRepositoryListener
extension ChatViewController: NotificationRepositoryListener {
    func receivedNotification(type: APNsNotificationType) {
        switch type {
        case .newMessage(let pushCustomerId):
            viewModel.reloadData(pushCustomerId: pushCustomerId)
        default: break
        }
    }
    
    func receivedNotificationInteraction(type: APNsNotificationType) { }
}
