//
//  UIColor.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 3/3/19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
