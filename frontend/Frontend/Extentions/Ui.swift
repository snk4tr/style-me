//
//  Ui.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 3/3/19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit

extension UIButton {
    func redrawWithColor(color: UIColor) {
        let origImage = self.imageView?.image
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}
