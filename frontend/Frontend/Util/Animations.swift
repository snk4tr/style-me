//
//  Animations.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 3/2/19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit

func mimicScreenShotFlash(target: UIViewController) {
    
    let aView = UIView(frame: target.view.frame)
    aView.backgroundColor = UIColor.white
    target.view.addSubview(aView)
    
    UIView.animate(withDuration: 0.65, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in
        aView.alpha = 0.0
    }, completion: { (done) -> Void in
        aView.removeFromSuperview()
    })
}
