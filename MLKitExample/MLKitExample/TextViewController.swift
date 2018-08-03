//
//  TextViewController.swift
//  MLKitExample
//
//  Created by Chanho Park on 2018. 8. 3..
//  Copyright © 2018년 Chanho Park. All rights reserved.
//


import UIKit
import Firebase

class TextViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    lazy var vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        textRecognizer = vision.onDeviceTextRecognizer()

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
            imageView.image = pickedImage

            let visionImage = VisionImage(image: pickedImage)
            textRecognizer?.process(visionImage) { (result, error) in
                guard error == nil, let result = result else {
                    self.resultView.text = "Could not recognize any text"
                    self.dismiss(animated: true, completion: nil)
                    return
                }

                self.resultView.text = "Detected Text Has \(result.blocks.count) Blocks:\n\n"
                for block in result.blocks {
                    self.resultView.text = self.resultView.text + "\(block.text)\n\n"
                }

            }
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
