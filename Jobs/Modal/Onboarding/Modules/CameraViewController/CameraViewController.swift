//
//  CameraViewController.swift
//  MessengerPlus
//
//  Created by Nikita Benin on 15.01.2022.
//  Copyright © 2022 Nikita Benin. All rights reserved.
//

import UIKit

import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func didTakePhoto(image: UIImage)
}

private struct Constants {
    static let screenSize = UIScreen.main.bounds
    static let viewAreaWidth = screenSize.width - 60
    static let viewAreaHeight = viewAreaWidth / 2
    static let centerPoint = CGPoint(
        x: (screenSize.width - viewAreaWidth) / 2,
        y: (screenSize.height - viewAreaHeight) / 2
    )
    static let viewAreaRect = CGRect(origin: centerPoint, size: CGSize(width: viewAreaWidth, height: viewAreaHeight))
}

class CameraViewController: UIViewController {
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var coverView: CameraCoverView = {
        let view = CameraCoverView()
        view.backgroundColor = .black
        view.visibleAreaRect = Constants.viewAreaRect
        view.alpha = 0.3
        return view
    }()
    private let shutterButton = CameraShutterButton()
    
    // MARK: - Variables
    private var session: AVCaptureSession?
    private let output = AVCapturePhotoOutput()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    weak var delegate: CameraViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
        setupViews()
        setupConstraints()
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .authorized:
            setUpCamera()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.frame = view.bounds
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        title = "Scan license plate"
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(imageView)
        view.addSubview(coverView)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        view.addSubview(shutterButton)
    }
    
    private func setupConstraints() {
        coverView.frame = view.bounds
        imageView.frame = view.bounds
        shutterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom).inset(10)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
                let image = UIImage(data: data) else { return }

        imageView.image = image
        session?.stopRunning()
        
        if let croppedImage = view.asImage().croppedInRect(rect: Constants.viewAreaRect) {
            delegate?.didTakePhoto(image: croppedImage)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
