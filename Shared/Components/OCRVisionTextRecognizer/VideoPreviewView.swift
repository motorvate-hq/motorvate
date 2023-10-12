//
//  VideoPreviewView.swift
//  Motorvate
//
//  Created by Emmanuel on 5/25/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import AVFoundation
import UIKit

class VideoPreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
      guard let layer = layer as? AVCaptureVideoPreviewLayer else {
          fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check VideoPreviewView.layerClass implementation.")
      }
      return layer
    }

    var session: AVCaptureSession? {
      get { return videoPreviewLayer.session }
      set { videoPreviewLayer.session = newValue }
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
