//
//  UIImage.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 2/3/19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit

extension UIImage {
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return normalizedImage ?? self;
    }
    
    func containsPerson() -> Bool {
        return true
    }
}
