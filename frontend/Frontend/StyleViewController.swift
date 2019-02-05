//
//  StyleViewController.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 11//19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class StyleViewController: UIViewController {

    
    @IBOutlet weak var stylizedImage: UIImageView!
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylizedImage.image = capturedImage
    }
    
    @IBAction func onStylizeTap(_ sender: UIButton) {
        // Make orientation of the image always to be "up".
        let correctlyOrientedImage = stylizedImage.image?.correctlyOrientedImage()
        
        // Transorm to jpeg representation with a slight compression.
        let imgData = correctlyOrientedImage!.jpegData(compressionQuality: 0.8)
        
        // Upload init image, dowload stylized from backend
        Alamofire.upload(imgData!, to:"http://192.168.0.106:8080/style")
            .responseImage { response in
                guard let image = response.result.value else {
                    // Handle error
                    print("ERROR")
                    return
                }
                // Set image as new UIImageView
                DispatchQueue.main.async {
                    self.stylizedImage.image = image
                }
                print("DONE")
        }
    }
    
    @IBAction func onSaveTap(_ sender: UIButton) {
        // TODO: implement
    }
}
