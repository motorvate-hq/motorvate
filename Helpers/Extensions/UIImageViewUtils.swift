//
//  UIImageViewUtils.swift
//  Motorvate
//
//  Created by Emmanuel on 6/4/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Kingfisher

import UIKit

typealias HasLoadedImageResponseHandler = ((Bool) -> Void)?

extension UIImageView {
    func loadImage(
            at url: URL?,
            placeholder: UIImage? = nil,
            placeholderContentMode: UIView.ContentMode = .scaleAspectFit,
            imageContentMode: UIView.ContentMode = .scaleAspectFill,
            showLoadingIndicator: Bool = true,
            hasLoadedImage: HasLoadedImageResponseHandler = nil) {
        
        guard let url = url else {
            self.contentMode = placeholderContentMode
            self.image = placeholder
            return
        }
        
        self.image = nil
        self.contentMode = imageContentMode
        
        self.kf.indicatorType = showLoadingIndicator ? .activity : .none
        self.kf.setImage(
            with: url,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ],
            completionHandler: { [weak self] result in self?.handleCompletion(result: result, hasLoadedImage: hasLoadedImage) })
    }
    
    private func handleCompletion(result: Result<RetrieveImageResult, KingfisherError>, hasLoadedImage: HasLoadedImageResponseHandler) {
        guard let hasLoadedImage = hasLoadedImage else { return }
        switch result {
        case .success:
            hasLoadedImage(true)
        case .failure:
            hasLoadedImage(false)
        }
    }

    func cancelImageLoad() {
        self.kf.cancelDownloadTask()
        self.kf.setImage(with: URL(string: ""))
        self.image = nil
    }
}
