//
//  Animations.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 3/2/19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit

func mimicScreenShotFlash(target: UIViewController) {
    // Adds flash animation.
    // Supposed to be used when user takes a new picture.
    
    let aView = UIView(frame: target.view.frame)
    aView.backgroundColor = UIColor.white
    target.view.addSubview(aView)
    
    UIView.animate(withDuration: 0.65, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in
        aView.alpha = 0.0
    }, completion: { (done) -> Void in
        aView.removeFromSuperview()
    })
}

func activityStartAnimating(target: UIViewController) -> UIActivityIndicatorView {
    // Starts standard spinner animation.
    // Supposed to be used while style request being processed.
    
    // Create the activity indicator.
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.style = .whiteLarge
    activityIndicator.color = .gray
    
    // Add it as a  subview.
    target.view.addSubview(activityIndicator)
    
    // Put in the middle
    activityIndicator.center = CGPoint(x: target.view.frame.size.width * 0.5, y: target.view.frame.size.height * 0.5)
    activityIndicator.startAnimating()
    return activityIndicator
}

func activityStopAnimating(activityIndicator: UIActivityIndicatorView) {
    // Stops standard spinner animation.
    // Supposed to be used when style request either succeed or failed.
    
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
}
