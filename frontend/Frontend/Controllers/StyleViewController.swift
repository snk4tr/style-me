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
        guard let imgData = retrieveImgData() else {
            debugPrint("Unsuccessful image loading")
            return
        }
        
        let requestPath = configureConnection(task: "style")
        
        let manager = Alamofire.SessionManager.default
        let timeout = Double(Environment().configuration(PlistKey.TimeoutInterval)) ?? 20
        manager.session.configuration.timeoutIntervalForRequest = timeout
        
        let animator = activityStartAnimating(target: self)
        
        // Upload init image, dowload stylized from backend
        manager.upload(imgData, to: requestPath)
            .responseImage { response in
                guard let image = response.result.value else {
                    
                    // On fail stop animating
                    activityStopAnimating(activityIndicator: animator)
                    
                    // Handle error
                    self.showAlertWith(title: "Something went wrong", message: "Please check your connection settings and backend avaliability")
                    debugPrint("ERROR")
                    return
                }
                // On response stop animating
                activityStopAnimating(activityIndicator: animator)
                
                // Set image as new UIImageView
                DispatchQueue.main.async {
                    self.stylizedImage.image = image
                }
                debugPrint("DONE")
        }
    }
    
    func retrieveImgData() -> Data? {
        /*
         Performs all actions related to retrieving of image data e.g. retrieving correctly
         oriented image from the UIImageView, checking whether it has a valid content and actual
         transformation to a format used for image transfering.
         */
        guard let correctlyOrientedImage = stylizedImage.image?.correctlyOrientedImage() else {
            showAlertWith(title: "Stylization error", message: "Please provide a photo with a person")
            return nil
        }
        
        if !correctlyOrientedImage.containsPerson() {
            showAlertWith(title: "Stylization error", message: "Please provide a photo with a person")
            print("HERE")
            return nil
        }
        
        // Transorm to jpeg representation with a slight compression.
        guard let imgData = correctlyOrientedImage.jpegData(compressionQuality: 0.8) else {
            showAlertWith(title: "Conversion error", message: "The image could not be converted to jpeg")
            return nil
        }
        
        return imgData
    }
    
    func configureConnection(task: String) -> String {
        let url = Environment().configuration(PlistKey.ServerURL)
        let port = Environment().configuration(PlistKey.ServerPort)
        let prot = Environment().configuration(PlistKey.ConnectionProtocol)
        return "\(prot)://\(url):\(port)/\(task)"
    }
    
    @IBAction func onSaveTap(_ sender: UIButton) {
        guard let selectedImage = self.stylizedImage.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
            return
        }
        showAlertWith(title: "Saved!", message: "Your image has been saved to your photo library.")
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
