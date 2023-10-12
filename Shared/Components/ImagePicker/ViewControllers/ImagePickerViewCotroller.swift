//
//  ImagePickerViewCotroller.swift
//  Motorvate
//
//  Created by Emmanuel on 10/13/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerViewControllerDelegate: AnyObject {
    func imagePickerViewCotroller(_ imagePicker: ImagePickerViewController, didFinishWithImage image: UIImage)
}

final class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var delegate: ImagePickerViewControllerDelegate?
    fileprivate var imagePickerController = UIImagePickerController()

    init() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePickerController.sourceType = .camera
        }
        super.init(nibName: nil, bundle: nil)
        self.imagePickerController.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public
extension ImagePickerViewController {
    public func present(from presentingViewController: UIViewController) {
        presentingViewController.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissController()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  else { return }
        delegate?.imagePickerViewCotroller(self, didFinishWithImage: originalImage)
        dismissController()
    }

    func dismissController() {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
