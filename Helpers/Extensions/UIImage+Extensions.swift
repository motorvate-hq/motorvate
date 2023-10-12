//
//   UIImage+Extensions.swift
//  Motorvate
//
//  Created by Emmanuel on 5/1/18.
//  Copyright © 2018 motorvate. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func imageWithImage(_ image: UIImage?, _ scaledToSize: CGSize) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    
    static func renderModeOriginal(_ name: String) -> UIImage? {
        let image = UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
        return image
    }
}
