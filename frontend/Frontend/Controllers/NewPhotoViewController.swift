//
//  ViewController.swift
//  Frontend
//
//  Created by Sergey Kastryulin on 3112//18.
//  Copyright © 2018 snk4tr. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class NewPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var capturedImage: UIImage!                           // Used as a proxy to transfer photos between views
    var imagePicker: UIImagePickerController!             // An object for loading images from photo library
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var switchCamera: UIButton!
    @IBOutlet weak var loadFromGalery: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Redraw buttons with another color
        switchCamera.redrawWithColor(color: .white)
        loadFromGalery.redrawWithColor(color: .white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create a new session.
        captureSession = AVCaptureSession()
        
        // Configure the session for high resolution still photo capture.
        captureSession.sessionPreset = .medium
        
        // Accessing a back camera which is a default one.
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            // Input of the device
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            // Output of the device
            stillImageOutput = AVCapturePhotoOutput()
            
            // If there are no errors from our last step and the session is able to accept input and output, the go ahead and add input add output to the Session.
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /** Destructor method. Cleans up session when user leaves camera view. **/
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func setupLivePreview() {
        // Get our Live Preview going so we can actually display what the camera sees on the screen in our UIView, previewView.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // Fills full screen. Use .resizeAspect to preserve ratio instead.
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        // Start the Session on the background thread.
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            
            // Size the Preview Layer to fit the Preview View.
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    @IBAction func didTakePhoto(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        mimicScreenShotFlash(target: self)
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func didSwitchCamera(_ sender: UIButton) {
        // To replace input device a few steps of configuration required:
        captureSession.beginConfiguration()
        
        // 1) Get current input
        guard let currentCameraInput : AVCaptureInput = captureSession.inputs.first
            else {
                print("Couldn't get current input device!")
                return
        }
        
        // And remove it
        captureSession.removeInput(currentCameraInput)
        
        // 2) Get new input
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = cameraWithPosition(position: .front)
            } else {
                newCamera = cameraWithPosition(position: .back)
            }
        }
        
        // And add it as a new main input
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: newCamera))
        } catch {
            print("Error adding video input device")
        }
        
        // 3) Commit changes
        captureSession.commitConfiguration()
    }
    
    @IBAction func didCaptureButton(_ sender: UIButton) {
        if capturedImage != nil {
            performSegue(withIdentifier: "stylePhoto", sender: self)
            return
        }
        
        print("captureButton's background image has not been set!")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo:
        AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        // Both have to be updated: proxy image storage and buttons image view
        capturedImage = UIImage(data: imageData)
        captureButton.setImage(capturedImage, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stylePhoto" {
            if let svc = segue.destination as? StyleViewController {
                svc.capturedImage = capturedImage
            }
        }
    }
    
    @IBAction func didLoadTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            return
        }
        
        // .savedPhotosAlbum is unavaliable
        print("Photo library for some reason is unavaliable")
    }
}


// Provides image loading functionality
extension NewPhotoViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        // Both have to be updated: proxy image storage and buttons image view
        capturedImage = selectedImage
        captureButton.setImage(selectedImage, for: .normal)
    }
}



