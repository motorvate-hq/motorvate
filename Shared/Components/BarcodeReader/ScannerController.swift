//
//  ScannerController.swift
//  Motorvate
//
//  Created by Emmanuel on 8/23/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol ScannerControllerDelegate: AnyObject {
    func scannerDidComplete(with vehicleIdentification: String)
    func scannerDidFail(with message: String)
}

class ScannerController {

    private var viewModel: BarcodeViewModel
    private let presentingViewController: UIViewController

    private let barcodeReaderView = BarcodeReaderView()

    weak var delegate: ScannerControllerDelegate?

    init(viewModel: BarcodeViewModel, presentingViewController: UIViewController) {
        self.viewModel = viewModel
        self.presentingViewController = presentingViewController

        self.barcodeReaderView.delegate = self
    }

    public var barcodeView: UIView {
        return barcodeReaderView
    }

    public func resetViewState() {
        barcodeReaderView.setVehicleIdentificationNumber(nil)
    }
}

extension ScannerController {
    private func present() {
        let textRecognitionHandler = TextRecognitionHandler()
        textRecognitionHandler.delegate = self
        textRecognitionHandler.presentCamera(from: presentingViewController)
    }
    
    func push() {
        let textRecognitionHandler = TextRecognitionHandler()
        textRecognitionHandler.delegate = self
        textRecognitionHandler.pushCamera(from: presentingViewController, title: "Scan VIN")
    }
}

// MARK: - BarcodeReaderViewDelegate
extension ScannerController: BarcodeReaderViewDelegate {
    func barcodeReaderView(_ barcodeView: BarcodeReaderView, didPress button: UIButton) {
        present()
    }
}

extension ScannerController: TextRecognitionHandlerDelegate {
    func textRecognition(_ handler: TextRecognitionHandler, didRecognize text: String?, error: TextRecognitionHandlerError?) {
        DispatchQueue.main.async {
            if let vehicleIdentificationNumber = text {
                self.barcodeReaderView.setVehicleIdentificationNumber(vehicleIdentificationNumber)
                self.delegate?.scannerDidComplete(with: vehicleIdentificationNumber)
            } else {
                self.delegate?.scannerDidFail(with: error?.message ?? "")
            }
        }
    }
}

extension TextRecognitionHandlerError {
    var message: String {
        switch self {
        case .noResultsFound:
            return "No results found"
        case .requestFailed(let message):
            return message
        case .textObservationCastFailed:
            return "Failed to cast"
        }
    }
}
