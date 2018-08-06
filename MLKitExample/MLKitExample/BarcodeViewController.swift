//
//  BarcodeViewController.swift
//  MLKitExample
//
//  Created by Chanho Park on 2018. 8. 3..
//  Copyright © 2018년 Chanho Park. All rights reserved.
//

import UIKit
import Firebase

class BarcodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    let options = VisionBarcodeDetectorOptions(formats: .all)
    lazy var vision = Vision.vision()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let spinner = UIViewController.displaySpinner(onView: self.view)
            imageView.image = pickedImage

            let barcodeDetector = vision.barcodeDetector(options: options)
            let visionImage = VisionImage(image: pickedImage)
            barcodeDetector.detect(in: visionImage) { (barcodes, error) in
                guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                    self.dismiss(animated: true, completion: nil)
                    self.resultView.text = "No Barcode Detected"
                    UIViewController.removeSpinner(spinner: spinner)
                    return
                }

                for barcode in barcodes {
                    let rawValue = barcode.rawValue!
                    let valueType = barcode.valueType

                    switch valueType {
                    case .URL:
                        self.resultView.text = "URL: \(rawValue)"
                    case .phone:
                        self.resultView.text = "Phone number: \(rawValue)"
                    default:
                        self.resultView.text = rawValue
                    }
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
