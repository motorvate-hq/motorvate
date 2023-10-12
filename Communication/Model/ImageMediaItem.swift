//
//  ImageMediaItem.swift
//  Motorvate
//
//  Created by Emmanuel on 9/6/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import MessageKit
import UIKit

struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.placeholderImage = UIImage()
        self.size = CGSize(width: 200, height: 200)
    }
}
