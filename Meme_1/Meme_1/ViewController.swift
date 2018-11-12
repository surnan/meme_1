//
//  ViewController.swift
//  Meme_1
//
//  Created by admin on 11/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var image: UIImage!     //set via UIImagePickerController()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK:- UIToolbar Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)    }
    
    //MARK:- ImagePickerController Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("PICKED AN IMAGE")
        if let tempImage = info[.originalImage] as? UIImage {
            self.image = tempImage
        }
        dismiss(animated: true, completion: nil)
    }
}


