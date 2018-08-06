//
//  LandMarkViewController.swift
//  MLKitExample
//
//  Created by Chanho Park on 2018. 8. 3..
//  Copyright © 2018년 Chanho Park. All rights reserved.
//


import UIKit
import Firebase

class LandmarkViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    let options = VisionCloudDetectorOptions()
    lazy var vision = Vision.vision()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        options.modelType = .latest
        options.maxResults = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let spinner = UIViewController.displaySpinner(onView: self.view)
            imageView.image = pickedImage
            
            let landmarkDetector = vision.cloudLandmarkDetector(options: options)
            let visionImage = VisionImage(image: pickedImage)
            
            self.resultView.text = ""
            landmarkDetector.detect(in: visionImage) { (landmarks, error) in
                guard error == nil, let landmarks = landmarks, !landmarks.isEmpty else {
                    self.resultView.text = "No landmarks detected"
                    self.dismiss(animated: true, completion: nil)
                    UIViewController.removeSpinner(spinner: spinner)
                    return
                }
                
                for landmark in landmarks {
                    let landmarkDesc = landmark.landmark!
                    let confidence = Float(truncating: landmark.confidence!)
                    self.resultView.text = self.resultView.text + "\(landmarkDesc) - \(confidence * 100.0)%\n\n"
                }
                UIViewController.removeSpinner(spinner: spinner)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

