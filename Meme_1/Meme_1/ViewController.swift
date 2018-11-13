//
//  ViewController.swift
//  Meme_1
//
//  Created by admin on 11/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    //MARK:- UITextField
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField! {
        didSet{
            //topTextField = setupTextField() // ERROR
            topTextField = setupTextField(textField: topTextField)
            topTextField.text = "TOP"
        }
    }
    
    @IBOutlet weak var bottomTextField: UITextField!{
        didSet{
            bottomTextField = setupTextField(textField: bottomTextField)
            bottomTextField.text = "BOTTOM"
        }
    }
    
    
    @objc func myTextFieldTextChanged (textField: UITextField) {
        textField.text =  textField.text?.uppercased()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    func setupTextField(textField: UITextField) -> UITextField{
        let tempTextField = textField
        tempTextField.clearsOnBeginEditing = true
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.6
        ]
        tempTextField.defaultTextAttributes = memeTextAttributes
        tempTextField.textAlignment = .center
        return tempTextField
    }
    
    
    func setupTextField() -> UITextField {
        let tempTextField = UITextField()
        tempTextField.clearsOnBeginEditing = true
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.6
        ]
        tempTextField.defaultTextAttributes = memeTextAttributes
        tempTextField.textAlignment = .center
        return tempTextField
    }
    
    var image: UIImage!     //set via UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        [topTextField, bottomTextField].forEach{
            $0.addTarget(self, action: #selector(myTextFieldTextChanged), for: UIControl.Event.editingChanged)
        }
        
        [topTextField, bottomTextField].forEach{$0?.delegate = self}
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


