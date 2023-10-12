//
//  TextRecognitionHandler.swift
//  Motorvate
//
//  Created by Emmanuel on 5/25/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation
import UIKit
import Vision

protocol TextRecognitionHandlerDelegate: AnyObject {
    func textRecognition(_ handler: TextRecognitionHandler, didRecognize text: String?, error: TextRecognitionHandlerError?)
}

enum TextRecognitionHandlerError: Error {
    case requestFailed(message: String)
    case textObservationCastFailed
    case noResultsFound
}

class TextRecognitionHandler {
    private lazy var request: VNRecognizeTextRequest = setupTextDetectionRequest()
    private let captureViewController: CaptureViewController = CaptureViewController()

    weak var delegate: TextRecognitionHandlerDelegate?

    public func presentCamera(from presentingViewController: UIViewController) {
        captureViewController.imageCapturedCompletion = handleRequest
        presentingViewController.modalPresentationStyle = .overCurrentContext
        presentingViewController.present(captureViewController, animated: true, completion: nil)
    }
    
    public func pushCamera(from presentingViewController: UIViewController, title: String) {
        captureViewController.imageCapturedCompletion = handleRequest
        captureViewController.title = title
        presentingViewController.navigationController?.pushViewController(captureViewController, animated: true)
    }

    public func dissmissCamera() {
        captureViewController.dismiss(animated: true, completion: nil)
    }
}

private extension TextRecognitionHandler {
    func setupTextDetectionRequest() -> VNRecognizeTextRequest {
        let textDetextRequest = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        textDetextRequest.recognitionLevel = .accurate
        textDetextRequest.revision = VNRecognizeTextRequestRevision1
        textDetextRequest.usesLanguageCorrection = false
        return textDetextRequest
    }

    func handleRequest(imageBuffer: CVImageBuffer?) {
        guard let pixelBuffer = imageBuffer else { return }

        request.regionOfInterest = captureViewController.regionOfInterest
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: captureViewController.textOrientation, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform image request: \(error)")
            return
        }
    }

    func handleDetectedText(request: VNRequest, error: Error?) {
        guard error == nil else {
            dissmissCamera()
            delegate?.textRecognition(self, didRecognize: nil, error: .requestFailed(message: error?.localizedDescription ?? ""))
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }

        let maximumCandidates = 1
        for textObservation in observations {
            guard let candidate = textObservation.topCandidates(maximumCandidates).first else { continue }
            let candidateStringValue = candidate.string

            print("textObservation \(candidateStringValue)")
            if candidateStringValue.isValidVehicleIdentificationNumber() {
                captureViewController.showString(string: candidateStringValue)
                delegate?.textRecognition(self, didRecognize: candidateStringValue, error: nil)
            }
        }
    }
}
