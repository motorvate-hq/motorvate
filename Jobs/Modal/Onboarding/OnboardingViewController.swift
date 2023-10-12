//
//  OnboardingViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-08-08.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private enum Constant {
    static let title = "Start Onboard"
    static let topOffset: CGFloat = 12
    static let vinRequiredTitleMessage = "Vehicle Identification number is required"
    static let vinRequiredTextMessage = "A: Scan License Plate\nor\nB: Scan VIN Number"
    static let requiredJobTypeMessage = "Job type is required"
    static let selectInquiryMessage = "Please select an inquiry or creating new drop-off to create job"
}

final class OnboardingViewController: UIViewController {

    private let stackScrollView = StackScrollView()
    private let footerView: FooterView = {
        let view = FooterView.loadFromNib()
        view.styleTutorialButton()
        view.createButton.setTitle("Create Job", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let scanView = ScanView()
    private let selectOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "SELECT ONBOARD OPTION"
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    private let manualVinInputView = ManualVinInputView()
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(
            string: "We’ll provide the year, make, model and image of your customers vehicle instantly.\n\nTip: Tap customer profile to update the job or service once customer profile  is complete  🚗✌🏽"
        )
        attributedText.setFontForText(
            textForAttribute: "Tip:",
            withFont: AppFont.archivo(.bold, ofSize: 13)
        )
        attributedText.setFontForText(
            textForAttribute: "Tap customer profile to update the job or service once customer profile  is complete",
            withFont: AppFont.archivo(.italic, ofSize: 13)
        )
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()

    private let viewModel: OnboardViewModel
    private var scannerController: ScannerController?
    private let serviceInformationView: ServiceInformationView
    private let vehicleCondition: VehicleConditionViewController
    private lazy var customerInquiryViewController: CustomerInquiryViewController = {
        let controller = CustomerInquiryViewController(self.viewModel)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private var shouldShowCustomerInquiryView: Bool {
        viewModel.shouldShowCustomerInquiryView
    }

    private var stackViewYAxisAnchor: NSLayoutYAxisAnchor {
        shouldShowCustomerInquiryView ? customerInquiryViewController.view.bottomAnchor : view.safeAreaLayoutGuide.topAnchor
    }

    init(_ viewModel: OnboardViewModel) {
        self.viewModel = viewModel
        self.vehicleCondition = VehicleConditionViewController(with: viewModel)
        self.serviceInformationView = ServiceInformationView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)

        self.scannerController = ScannerController(viewModel: BarcodeViewModel(), presentingViewController: self)
        scannerController?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCloseButton()
        setLeftBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        footerView.delegate = self
        hideKeyboardWhenTappedAround()
        registerNotifications()
    }

    @objc func didPressCloseButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

private extension OnboardingViewController {
    private func setUI() {
        title = Constant.title
        view.backgroundColor = .systemGray6

        if shouldShowCustomerInquiryView {
            configureCustomerInquiryViewController()
        }

        stackScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        stackScrollView.keyboardDismissMode = .interactive
        
        stackScrollView.insertView(selectOptionLabel)
        
        scanView.delegate = self
        stackScrollView.insertView(scanView)

        stackScrollView.insertView(manualVinInputView)
        stackScrollView.insertView(serviceInformationView)
        stackScrollView.insertView(tipLabel)
        view.addSubview(stackScrollView)
        NSLayoutConstraint.activate([
            stackScrollView.topAnchor.constraint(equalTo: stackViewYAxisAnchor, constant: Constant.topOffset),
            stackScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        stackScrollView.setCustomSpacing(6, after: scanView)

        view.addSubview(footerView)
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func configureCustomerInquiryViewController() {
        view.addSubview(customerInquiryViewController.view)
        NSLayoutConstraint.activate([
            customerInquiryViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.topOffset),
            customerInquiryViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customerInquiryViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customerInquiryViewController.view.heightAnchor.constraint(equalToConstant: 100)
        ])
        addChild(customerInquiryViewController)
        customerInquiryViewController.didMove(toParent: self)
        customerInquiryViewController.selectInquiryHandler = handleSelectInquiry
    }
    
    private func handleSelectInquiry(_ inquiry: Inquiry) {
        serviceInformationView.setServiceDetails(serviceDetails: inquiry.inquiryDetails)
    }

    private func setupCloseButton() {
        let backItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didPressCloseButton))
        navigationItem.rightBarButtonItem = backItem
    }

    private func setLeftBarButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.setHidesBackButton(true, animated: false)
    }
}

// MARK: - ScanViewDelegate
extension OnboardingViewController: ScanViewDelegate {
    func handleScan(type: ScanButtonType) {
        manualVinInputView.setManualVin("")
        switch type {
        case .licensePlate:
            let cameraViewController = CameraViewController()
            cameraViewController.delegate = self
            navigationController?.pushViewController(cameraViewController, animated: true)
        case .vin:
            scannerController?.push()
        }
    }
}

// MARK: - CameraViewControllerDelegate
extension OnboardingViewController: CameraViewControllerDelegate {
    func didTakePhoto(image: UIImage) {
        scanView.setState(.loading)
        manualVinInputView.isUserInteractionEnabled = false
        manualVinInputView.alpha = 0.5
        viewModel.readLicensePlate(image: image, completion: { [weak self] scanResult, errorType  in
            guard let strongSelf = self else { return }
            strongSelf.manualVinInputView.isUserInteractionEnabled = true
            strongSelf.manualVinInputView.alpha = 1
            
            guard let scanResult = scanResult else {
                let error = errorType?.errorText ?? "Unknown scan error"
                strongSelf.scanView.setState(.normal)
                BaseViewController.presentAlert(message: error, from: strongSelf)
                return
            }
            
            strongSelf.manualVinInputView.setManualVin(scanResult.vin)
            strongSelf.scanView.setState(.scannedPlate(plate: scanResult.licensePlateString))
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.footerView.styleResetButton()
            }
        })
    }
}

extension OnboardingViewController: ScannerControllerDelegate {
    func scannerDidComplete(with vehicleIdentification: String) {
        viewModel.vehicleIdentificationNumber = vehicleIdentification
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.footerView.styleResetButton()
        }
        manualVinInputView.setManualVin(vehicleIdentification)
        scanView.setState(.scannedVin(vin: vehicleIdentification))
        navigationController?.popViewController(animated: true)
    }

    func scannerDidFail(with message: String) {
        BaseViewController.presentAlert(message: "Error occured while decoding vehicle vin. Select Continue to enter manually", from: self)
    }
}

// MARK: FooterViewDelegate
extension OnboardingViewController: FooterViewDelegate {
    func footerView(_ footerView: UIView, didPressButton type: FooterButtonType) {
        serviceInformationView.setData()
        switch type {
        case .create:
            didPressCreateButton()
        case .save:
            self.footerView.isShowingTutorialButton ? didPressTutorialButton() : didPressResetButton()
        case .cancel:
            break
        }
    }
    
    private func didPressTutorialButton() {
        AnalyticsManager.logEvent(.watchOnboardTutorial)
        present(VideoController(videoType: .vehilceOnboardingTutorial), animated: true)
    }

    func didPressResetButton() {
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.scanView.alpha = 0
        }, completion: { [weak self] _ in
            self?.scanView.setState(.normal)
            self?.manualVinInputView.setManualVin("")
            
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.scanView.alpha = 1
            }
        })
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.footerView.styleTutorialButton()
        }, completion: { [weak self] _ in
            self?.scannerController?.resetViewState()
            self?.viewModel.vehicleIdentificationNumber = nil
        })
    }

    func didPressCreateButton() {
        if let manualVin = manualVinInputView.getManualVin(),
           !manualVin.isEmpty {
            viewModel.vehicleIdentificationNumber = manualVin
        }
        
        // Make sure there is always a jobType
        if viewModel.requiresJobType() {
            presentAlert(title: "", message: Constant.requiredJobTypeMessage)
            return
        }

        guard let vehicleVin = viewModel.vehicleIdentificationNumber else {
            presentAlert(title: Constant.vinRequiredTitleMessage, message: Constant.vinRequiredTextMessage)
            return
        }
        
        if viewModel.selectedIquiryID == nil && viewModel.shouldShowCustomerInquiryView {
            presentAlert(title: "", message: Constant.selectInquiryMessage)
            return
        }
        
        setAsLoading(true)
        viewModel.createJob(for: vehicleVin) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.setAsLoading(false)
            if let error = error {
                strongSelf.presentAlert(title: "Error", message: error.message)
                return
            }
            
            AnalyticsManager.logEvent(.startOnboard)
            if strongSelf.viewModel.shouldShowJobsScreenOnCreateInquiry {
                NotificationCenter.default.post(name: .showInqueueJobsOnScreen, object: nil)
            }
            strongSelf.handleJobCreationResponse()
        }
    }

    func didCompleteSuccessfully() {
        NotificationCenter.default.post(name: .RefetchInquiries, object: nil)
        NotificationCenter.default.post(name: .JobsViewControllerFetchAllJobs, object: nil)
        didPressCloseButton()
    }

    private func handleJobCreationResponse(error: Error? = nil) {
        setAsLoading(false)
        self.didCompleteSuccessfully()
    }
}

// MARK: - Keyboard notifications
extension OnboardingViewController {
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        stackScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        let bottomInset = UIScreen.main.bounds.maxY - (stackScrollView.firstResponder?.globalFrame?.maxY ?? 0) - 25        
        if bottomInset < keyboardHeight {
            let textRowOffsetY = stackScrollView.contentOffset.y + keyboardHeight - bottomInset
            stackScrollView.contentOffset = CGPoint(x: stackScrollView.contentOffset.x, y: textRowOffsetY)
        }
    }

    @objc private func keyboardWillHide() {
        stackScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
}
