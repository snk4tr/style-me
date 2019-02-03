//
//  Common.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 3112//18.
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
