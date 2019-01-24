//
//  StyleViewController.swift
//  Frontend
//
//  Created by Сергей Кастрюлин on 11//19.
//  Copyright © 2019 snk4tr. All rights reserved.
//

import UIKit
import Alamofire

class StyleViewController: UIViewController {

    
    @IBOutlet weak var stylizedImage: UIImageView!
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylizedImage.image = capturedImage
    }
    
    @IBAction func onStylizeTap(_ sender: UIButton) {
//        // prepare json data
//        let json: [String: Any] = ["image": stylizedImage.image!.pngData()!,
//                                   "description": "Image to be stylized"]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        // create post request
//        let url = URL(string: "95.24.0.56:8080/style")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON["description"])
//            }
//        }
//
//        task.resume()
        
        
        print("============================================================")
//        print(stylizedImage.image!.jpegData(compressionQuality: 1.0)!)
//        print(stylizedImage.image?.pixelData())
        print("============================================================")
//        print(stylizedImage.image?.pixelData()!.count)
//        for i in 0...2 {
//            print(stylizedImage.image?.pixelData()![i].count)
//        }
        let rgbImage = stylizedImage.image?.pixelData()!
        let serializableRgbImage = rgbImage!.map({String($0)})
//        var serializableRgbImage = [[String]]()
//        for i in 0..<rgbImage!.count {
//            serializableRgbImage.append(rgbImage![i].map({String($0)}))
//        }
        
        
//        print(stylizedImage.image?.pngData()!.base64EncodedString())
//        print(stylizedImage.image?.pixelData().base64EncodedString())
        print("============================================================")
        
        let parameters: [String: Any] = [
            "image": serializableRgbImage,
            "description": "Image to be stylized"
        ]
        
        AF.request("http://172.20.10.3:8080/style", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response.result.value)
            
            if let jsonDict = response.result.value as? Dictionary<String, Any> {
                print("11111111111111111111111111111111")
                let recievedImage = jsonDict["image"] as! [[UInt8]]
                let convertedImage = UIImageFromRGB(rgbImage: recievedImage)
                print("convertedImage.size: \(convertedImage!.size)")
                print("Before dispatch queue")
                DispatchQueue.main.async {
                    self.stylizedImage.image = convertedImage
                }
                print("After dispatch queue")
            }
            
            debugPrint("After if let")
        }
    }
    
    @IBAction func onSaveTap(_ sender: UIButton) {
    }
}
