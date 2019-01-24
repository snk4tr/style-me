//
//  UIImage.swift
//  Frontend
//
//  Created by Сергей Кастрюлин on 151//19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit

extension UIImage {
    func pixelData() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        
        // References on pixel data
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Define context
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        // Fill pixel data
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Reshape into 3D array (throw away alpha channel)
//        var red = [UInt8]()
//        var green = [UInt8]()
//        var blue = [UInt8]()
//
//        let numSteps = Int(dataSize) / 4
//        for step in 0..<numSteps {
//            red.append(pixelData[step])
//            green.append(pixelData[step+1])
//            blue.append(pixelData[step+2])
//        }
//
//        var reshapedPixelData = [[UInt8]]()
//        reshapedPixelData.append(red)
//        reshapedPixelData.append(green)
//        reshapedPixelData.append(blue)
        return pixelData
    }
}
