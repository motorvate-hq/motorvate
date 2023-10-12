//
//  CameraCoverView.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class CameraCoverView: UIView {
    var visibleAreaRect: CGRect? {
        didSet {
            lastProcessedSize = .zero
            createMask()
        }
    }

    private var lastProcessedSize = CGSize.zero

    override func layoutSubviews() {
        super.layoutSubviews()
        createMask()
    }

    private func createMask() {
        guard lastProcessedSize != frame.size,
              let visibleAreaRect = visibleAreaRect else { return }

        let size = frame.size

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        UIColor.white.setFill()
        context.fill(CGRect(origin: .zero, size: size))

        UIColor.black.setFill()
        
        context.addPath(
            UIBezierPath(roundedRect: visibleAreaRect, cornerRadius: 15).cgPath
        )
        context.fillPath()

        // apply filter to convert black to transparent
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let cgImage = image.cgImage,
            let filter = CIFilter(name: "CIMaskToAlpha")
            else { return }

        filter.setDefaults()
        filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        guard let result = filter.outputImage,
            let cgMaskImage = CIContext().createCGImage(result, from: result.extent)
            else { return }

        // Create mask
        let mask = CALayer()
        mask.frame = bounds
        mask.contents = cgMaskImage
        layer.mask = mask
    }
}
