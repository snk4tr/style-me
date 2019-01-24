//
//  Common.swift
//  Frontend
//
//  Created by Сергей Кастрюлин on 3112//18.
//  Copyright © 2018 snk4tr. All rights reserved.
//

import AVFoundation
import UIKit

func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    /**
     Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
     **/
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
    for device in discoverySession.devices {
        if device.position == position {
            return device
        }
    }
    
    return nil
}

func UIImageFromRGB(rgbImage: [[UInt8]]) -> UIImage? {
    var bitMap = [UInt8]()
    for pix in rgbImage {
        for p in pix {
            bitMap.append(p)
        }
        bitMap.append(255) // alpha channel
    }
    
    let image = maskFromData(data: &bitMap)
    return image
}


func maskFromData(data: inout [UInt8]) -> UIImage? {
    guard data.count >= 8 else {
        print("data too small")
        return nil
    }
    
    let width  = 480
    let height = 480
    
    guard data.count >= width * height + 8 else {
        print("data not large enough to hold \(width)x\(height)")
        return nil
    }
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    guard let bitmapContext = CGContext(data: &data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue) else {
        print("context is nil")
        return nil
    }
    
    guard let cgImage = bitmapContext.makeImage() else {
        print("image is nil")
        return nil
    }
    
    return UIImage(cgImage: cgImage)
}
