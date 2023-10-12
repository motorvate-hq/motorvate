//
//  WalkthroughController.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

protocol WalkthroughControllerDelegate: AnyObject {
    func showWalkthroughJobDetails(job: Job)
    func showWalkthroughAddJobDetials()
    func popViewController()
    func showMessages()
    func popToRootViewController()
    func showConnectBank()
}

class WalkthroughController: UIViewController {

    // MARK: UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        
        collectionView.register(WalkthroughJobCell.self)
        collectionView.register(WalkthroughJobDetailsCell.self)
        collectionView.register(WalkthroughAddServiceCell.self)
        collectionView.register(WalkthroughChatCell.self)
        
        return collectionView
    }()
    private let stepView = WalkthroughStepView()
    
    // MARK: Variables
    private var previousStep: WalkthroughStep?
    private var step: Box<WalkthroughStep> = Box<WalkthroughStep>(.scanVin)
    weak var delegate: WalkthroughControllerDelegate?
    private var jobDetails = ServiceDetail(id: nil, description: "", price: 0)
    private let stripeService = StripeService()
    private var showConnectBank = false
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.alpha = 1
        })
        AnalyticsManager.logEvent(.startedWalkThrough)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        hasConnectedBank()
        
        step.bind { [weak self] walkthroughStep in
            if walkthroughStep.rawValue >= self?.previousStep?.rawValue ?? -1 {
                self?.handleStepForward(step: walkthroughStep)
            } else {
                self?.handleStepBackward(step: walkthroughStep)
            }
            self?.stepView.setView(step: walkthroughStep)
            self?.previousStep = walkthroughStep
        }
    }
    
    private func hasConnectedBank() {
        guard let shopID = UserSession.shared.shopID else {
            showConnectBank = false
            return
        }
        let request = HasConnectedStripeRequest(shopID: shopID)
        stripeService.hasConnectedStripe(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.showConnectBank = !response.hasConnected
            case .failure(let error):
                self?.showConnectBank = false
                print("error:", error.localizedDescription)
            }
        }
    }
    
    private func handleStepForward(step: WalkthroughStep) {
        switch step {
        case .scanVin:
            break
        case .updateJobDetails:
            delegate?.showWalkthroughJobDetails(job: Job.walkthroughJob)
            scrollToItem(item: 1)
        case .enterJobDetails:
            delegate?.showWalkthroughAddJobDetials()
            scrollToItem(item: 2)
        case .editJobDetails:
            delegate?.popViewController()
            scrollToItem(item: 1)
        case .tapMessages:
            delegate?.popViewController()
            scrollToItem(item: 0)
        case .sendInvoice:
            delegate?.showMessages()
            scrollToItem(item: 3)
        case .confirmInvoice:
            break
        case .updateStatus:
            delegate?.popViewController()
            scrollToItem(item: 0)
        case .finishTutorial:
            break
        case .closeTutorial:
            finishTutorial()
        }
    }
    
    private func handleStepBackward(step: WalkthroughStep) {
        switch step {
        case .scanVin:
            delegate?.popToRootViewController()
            scrollToItem(item: 0)
        case .updateJobDetails:
            delegate?.showWalkthroughJobDetails(job: Job.walkthroughJob)
            scrollToItem(item: 1)
        case .enterJobDetails:
            delegate?.showWalkthroughAddJobDetials()
            scrollToItem(item: 2)
        case .editJobDetails:
            delegate?.popViewController()
            delegate?.showWalkthroughJobDetails(job: Job.walkthroughJob)
            scrollToItem(item: 1)
        case .tapMessages:
            delegate?.popViewController()
            scrollToItem(item: 0)
        case .sendInvoice:
            guard let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? WalkthroughChatCell else { return }
            cell.setCell(step: self.step)
        case .confirmInvoice:
            delegate?.showMessages()
            scrollToItem(item: 3)
        case .updateStatus:
            guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? WalkthroughJobCell else { return }
            cell.setCell(step: self.step)
        case .finishTutorial:
            break
        case .closeTutorial:
            break
        }
    }
    
    private func scrollToItem(item: Int) {
        collectionView.scrollToItem(
            at: IndexPath(item: item, section: 0),
            at: .left,
            animated: true
        )
    }
    
    // MARK: UI Setup
    private func setViews() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        stepView.delegate = self
        stepView.setView(step: step.value)
        view.addSubview(stepView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        stepView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeArea.top).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(160)
        }
    }
}

// MARK: UICollectionViewDelegate
extension WalkthroughController: UICollectionViewDelegate { }

// MARK: UICollectionViewDataSource
extension WalkthroughController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let screen = WalkthroughScreens(rawValue: indexPath.item) else { return }
        switch screen {
        case .jobs:
            guard let cell = cell as? WalkthroughJobCell else { return }
            cell.setCell(step: step)
        case .jobDetails:
            guard let cell = cell as? WalkthroughJobDetailsCell else { return }
            cell.setCell(step: step, jobDetails: jobDetails)
        case .messages:
            guard let cell = cell as? WalkthroughChatCell  else { return }
            cell.setCell(step: step)
        default: break
        }
        
        guard indexPath.item != 0 else { return }
        cell.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0.2, options: [], animations: {
            cell.alpha = 1
        }, completion: { _ in })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WalkthroughScreens.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let screen = WalkthroughScreens(rawValue: indexPath.item) else { return UICollectionViewCell() }
        switch screen {
        case .jobs:
            let cell: WalkthroughJobCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(step: step)
            return cell
        case .jobDetails:
            let cell: WalkthroughJobDetailsCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(step: step, jobDetails: jobDetails)
            return cell
        case .addService:
            let cell: WalkthroughAddServiceCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell { [weak self] jobDetails in
                guard let strongSelf = self else { return }
                if let jobDetails = jobDetails {
                    strongSelf.jobDetails = jobDetails
                    strongSelf.step.value = .editJobDetails
                } else {
                    BaseViewController.presentAlert(message: "All fields are required", from: strongSelf)
                }
            }
            return cell
        case .messages:
            let cell: WalkthroughChatCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(step: step)
            return cell
        }
    }
}

extension WalkthroughController: WalkthroughStepViewDelegate {
    func didChangeStep(stepNumber: Int) {
        step.value = WalkthroughStep(rawValue: step.value.rawValue + stepNumber) ?? .scanVin
    }
    
    func finishTutorial() {
        AnalyticsManager.logEvent(.finishedWalkThrough)
        delegate?.popToRootViewController()
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [weak self] in
            self?.view.alpha = 0
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: {
                guard let strongSelf = self else { return }
                if strongSelf.showConnectBank {
                    strongSelf.delegate?.showConnectBank()
                }
            })
        })
    }
}
