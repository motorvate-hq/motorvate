//
//  ChatViewModel.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-05-02.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

enum ChatAction {
    case reloadData
    case setLoadingMode(isOn: Bool)
    case showAlert(shouldClose: Bool, error: Error) // For now it is generic
    case showConnectBank
    case showEnableNotifications
}

final class ChatViewModel {

    private let chatService = ChatService()
    private let shopId: String? = UserSession.shared.shop?.id
    private var topicArn: String? = UserSession.shared.shop?.topicArn
    private var customerID: String?
    private(set) var chatHistory: ChatHistory?
    
    var jobStatus: Box<Job.Status> = Box<Job.Status>(.none)
    var messages: [Message] = []
    
    private var inquiryId: String?
    private var jobId: String?
    
    private var currentInquiry: Inquiry?
    private var currentJob: Job?

    var didReceiveAction: ((ChatAction) -> Void)?
    
    private let stripeService = StripeService()
    private var showConnectBank = false

    var customerNameText: String? {
        if let fullName = chatHistory?.customer.fullName {
            return fullName + "'s"
        }
        return nil
    }
    
    var customerCarText: String? {
        return currentJob?.vehicle?.description ?? currentInquiry?.model
    }
    
    var appUserSender: User {
        return UserSession.shared.user ?? User(userID: "", firstName: "", lastName: "")
    }
    
    var showDropDown: Bool {
        return (chatHistory?.inquiries?.count ?? 0) + (chatHistory?.jobs?.count ?? 0) > 1
    }
    
    private var isOpenedFromConversations: Bool = true
    
    private lazy var jobService: JobService = JobService()
    
    private var isWalkthrough = false
    
    init(isWalkthrough: Bool) {
        self.jobStatus = .init(.inProgress)
        self.isWalkthrough = isWalkthrough
    }

    init(chatHistory: ChatHistory?) {
        self.chatHistory = chatHistory
        
        self.topicArn = chatHistory?.topicArn
        self.customerID = chatHistory?.customer.customerID
    }

    init(customerID: String, inquiryId: String?, jobId: String?) {
        self.customerID = customerID
        
        self.inquiryId = inquiryId
        self.jobId = jobId
    }

    func viewDidLoad() {
        guard !isWalkthrough else {
            print("Showing chat in walkthrough mode.")
            return
        }
        if let chatHistory = chatHistory {
            isOpenedFromConversations = true
            configureFor(history: chatHistory)
        } else if let shopId = shopId, let customerID = customerID {
            isOpenedFromConversations = false
            fetchHistory(for: shopId, customerID: customerID)
        } else {
            print("Something is terribly wrong..")
            didReceiveAction?(.setLoadingMode(isOn: false))
        }
    }
    
    func getCurrentJob() -> Job? {
        return currentJob
    }
    
    func getCurrentInquiry() -> Inquiry? {
        return currentInquiry
    }

    // MARK: - Private operations
    private func fetchHistory(for shopID: String, customerID: String) {
        didReceiveAction?(.setLoadingMode(isOn: true))
        chatService.getHistory(shopID: shopID, customerID: customerID) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let history):
                strongSelf.configureFor(history: history)
            case .failure(let error):
                strongSelf.didReceiveAction?(.reloadData)
                strongSelf.didReceiveAction?(.setLoadingMode(isOn: false))
                CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                strongSelf.didReceiveAction?(.showAlert(shouldClose: true, error: error))
            }
        }
    }

    private func configureFor(history: ChatHistory) {
        chatHistory = history
        let customer = User(userID: "customer", firstName: "customer", lastName: "customer")

        updateCurrentJobInquiry(inquiryId: inquiryId, jobId: jobId)

        messages = history.chat.map({ chatMessage -> Message in
            return Message(text: chatMessage.text,
                           messageId: UUID().uuidString.lowercased(),
                           user: chatMessage.source == "user" ? appUserSender : customer,
                           date: DateFormatter().decodeServerDate(from: chatMessage.createDate))
        })

        didReceiveAction?(.reloadData)
        didReceiveAction?(.setLoadingMode(isOn: false))
        
        if isOpenedFromConversations {
            updateChatReadStatus()
        }
    }
    
    func updateCurrentJobInquiry(inquiryId: String?, jobId: String?) {
        jobStatus.value = .none
        
        if let inquiryId = inquiryId {
            self.inquiryId = inquiryId
            self.jobId = nil
            
            currentJob = nil
            setCurrentInquiry()
        } else if let jobId = jobId {
            self.inquiryId = nil
            self.jobId = jobId
            
            currentInquiry = nil
            setCurrentJob()
        } else {
            setCurrentInquiry()
            setCurrentJob()
        }
    }
    
    private func setCurrentInquiry() {
        if let inquiryId = inquiryId {
            currentInquiry = chatHistory?.inquiries?.first(where: { $0.id == inquiryId })
        } else {
            currentInquiry = chatHistory?.inquiries?.last
        }
    }
    
    private func setCurrentJob() {
        
        // Don't set job if we have inquiryId (when chat is opened from inquiry)
        guard inquiryId == nil else { return }
        
        if let jobId = jobId {
            currentJob = chatHistory?.jobs?.first(where: { $0.jobID == jobId })
        } else {
            currentJob = chatHistory?.jobs?.last
            jobId = currentJob?.jobID
        }
        
        if let status = currentJob?.status {
            jobStatus.value = status
        }
    }
    
    func reloadData(pushCustomerId: String?) {
        if let shopId = shopId, let customerId = customerID, let pushCustomerId = pushCustomerId {
            if pushCustomerId == customerId {
                fetchHistory(for: shopId, customerID: customerId)
            }
        }
    }
    
    func removeNotificationsBadge() {
        UIApplication.shared.applicationIconBadgeNumber = UserSettings().totalNotificationsCounter
    }
}

extension ChatViewModel {
    func checkIfNotifcationsEnabled() {
        NotificationRepository.shared.getAuthorizationStatus { [weak self] notificationsStatus in
            switch notificationsStatus {
            case .authorized:
                break
            case .notDetermined:
                NotificationRepository.shared.requestAuthorization()
            default:
                self?.didReceiveAction?(.showEnableNotifications)
            }
        }
    }
}

// MARK: - Internal API
extension ChatViewModel {
    func sendMessage(text: String) {
        checkIfNotifcationsEnabled()
        guard let shopId = shopId, let customerID = customerID, let topicArn = topicArn else {
            CrashlyticsManager.recordError(.fieldsNilValidationError(fields: ["shopId", "customerID", "topicArn"]))
            didReceiveAction?(.showAlert(shouldClose: true, error: FieldsValidationError()))
            return
        }

        let message = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let sender = ChatService.SenderConfiguration(shopID: shopId, topicArn: topicArn)
        chatService.send(message: message, from: sender, to: customerID) { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let history):
                AnalyticsManager.logEvent(.messageSent)
                strongSelf.configureFor(history: history)
            case .failure(let error):
                strongSelf.didReceiveAction?(.showAlert(shouldClose: false, error: error))
                strongSelf.didReceiveAction?(.reloadData)
            }
        }
    }
    
    func hasConnectedBank(action: @escaping () -> Void) {
        guard let shopID = UserSession.shared.shopID else {
            didReceiveAction?(.setLoadingMode(isOn: false))
            return
        }
        
        didReceiveAction?(.setLoadingMode(isOn: true))
        let request = HasConnectedStripeRequest(shopID: shopID)
        stripeService.hasConnectedStripe(request: request) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.didReceiveAction?(.setLoadingMode(isOn: false))
            switch result {
            case .success(let response):
                response.hasConnected ? action() : strongSelf.didReceiveAction?(.showConnectBank)
            case .failure(let error):
                print("error:", error.localizedDescription)
                CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                strongSelf.didReceiveAction?(.showAlert(shouldClose: false, error: error))
            }
        }
    }
    
    func sendInvoice(fee: DepositFeeType) {
        checkIfNotifcationsEnabled()
        guard let shopId = shopId,
              let customerPhone = chatHistory?.customer.phoneNumber?.dropFirst(),
              let jobId = jobId,
              let customerID = customerID,
              let topicArn = topicArn else {
            CrashlyticsManager.recordError(.fieldsNilValidationError(fields: ["shopId", "customerPhone", "jobId", "customerID", "topicArn"]))
            didReceiveAction?(.showAlert(shouldClose: false, error: FieldsValidationError()))
            return
        }
        
        hasConnectedBank { [weak self] in
            self?.didReceiveAction?(.setLoadingMode(isOn: true))
            let request = SendPaymentInvoiceRequest(
                shopID: shopId,
                customerPhone: String(customerPhone),
                jobID: jobId,
                customerID: customerID,
                topicArn: topicArn,
                feeFromShop: fee == .include
            )
            self?.jobService.sendPaymentInvoiceLink(request: request) { [weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.didReceiveAction?(.setLoadingMode(isOn: false))
                switch result {
                case .success(let history):
                    AnalyticsManager.logEvent(.invoiceSent)
                    strongSelf.configureFor(history: history)
                case .failure(let error):
                    CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                    strongSelf.didReceiveAction?(.showAlert(shouldClose: false, error: error))
                }
            }
        }
    }
    
    func sendEstimationLink(type: DepositEstimateType, fee: DepositFeeType) {
        guard let inquiryId = getCurrentInquiry()?.id else { return }
        let request = SendEstimationLinkRequest(
            inquiryID: inquiryId,
            depositPercent: Int(type.percent),
            feeFromShop: fee == .include
        )
        didReceiveAction?(.setLoadingMode(isOn: true))
        jobService.sendEstimationLink(request: request) { [weak self] result in
            switch result {
            case .success(let chatHistory):
                self?.configureFor(history: chatHistory)
            case .failure(let error):
                CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                self?.didReceiveAction?(.showAlert(shouldClose: false, error: error))
            }
        }
    }
    
    func updateChatReadStatus() {
        guard let shopId = shopId, let customerID = customerID else {
            CrashlyticsManager.recordError(.fieldsNilValidationError(fields: ["shopId", "customerID"]))
            didReceiveAction?(.showAlert(shouldClose: false, error: FieldsValidationError()))
            return
        }
        
        let request = UpdateReadStatusRequest(shopID: shopId, customerID: customerID)
        chatService.updateReadStatus(request: request, completion: { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                self?.didReceiveAction?(.showAlert(shouldClose: false, error: error))
            }
        })
    }
    
    func updateJobStatus(status: Job.Status) {
        guard let jobId = currentJob?.jobID else {
            CrashlyticsManager.recordError(.fieldsNilValidationError(fields: ["jobId"]))
            didReceiveAction?(.showAlert(shouldClose: true, error: FieldsValidationError()))
            return
        }
        
        didReceiveAction?(.setLoadingMode(isOn: true))
        let parameters: Parameters = ["status": status.value]
        jobService.update(jobID: jobId, parameters: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.didReceiveAction?(.setLoadingMode(isOn: false))
            switch result {
            case .success:
                AnalyticsManager.logJobStatusChange(status)
                NotificationCenter.default.post(name: .JobsViewControllerFetchAllJobs, object: nil)
                strongSelf.jobStatus.value = status
                
                if let index = strongSelf.chatHistory?.jobs?.firstIndex(where: { $0.jobID == jobId }) {
                    strongSelf.chatHistory?.jobs?[index].status = status
                }
            case .failure(let error):
                CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                strongSelf.didReceiveAction?(.showAlert(shouldClose: true, error: error))
                print("failed to update job with status error: \(error)")
            }
        }
    }
}
