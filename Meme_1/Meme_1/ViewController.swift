//
//  ViewController.swift
//  Meme_1
//
//  Created by admin on 11/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var finalImage = UIImage()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var toolBarTop: UIToolbar!
    
    //MARK:- UITextField Outlets & Code
    @IBOutlet weak var topTextField: UITextField! {
        didSet{
            //topTextField = setupTextField() // ERROR
            topTextField = setupTextField(textField: topTextField)
            topTextField.text = "TOP"
            topTextField.backgroundColor = UIColor.clear
            topTextField.borderStyle = .none
        }
    }
    
    @IBOutlet weak var bottomTextField: UITextField!{
        didSet{
            bottomTextField = setupTextField(textField: bottomTextField)
            bottomTextField.text = "BOTTOM"
            bottomTextField.backgroundColor = UIColor.clear
            bottomTextField.borderStyle = .none
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
    
    //MARK:- Default Swift Functions
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeToKeyboardNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        [topTextField, bottomTextField].forEach{
            $0.addTarget(self, action: #selector(myTextFieldTextChanged), for: UIControl.Event.editingChanged)
        }
        
        [topTextField, bottomTextField].forEach{$0?.delegate = self}
    }

    //MARK:- Keyboard

    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing == true {
            view.frame.origin.y = -getKeyboardHeight(notification)  // y=0 top of screen. We shift it upwards
        }
    }
   
    @objc func keyboardWillHide(_ notification: Notification) {
        //        view.frame.origin.y = getKeyboardHeight(notification)  // y=0 top of screen. We shift it upwards
        view.frame.origin.y = 0
    }
    
    private func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            return keyboardSize.height
        }
        return 0.0
    }

    
    
    
    //MARK:- UIToolbar Actions & Meme Generator
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
        if let tempImage = info[.originalImage] as? UIImage {
            backgroundImageView.image = tempImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveMeme(_ sender: Any) {
        
        toolBar.isHidden = true
        toolBarTop.isHidden = true
        var currentMeme = Meme(topTxtField: topTextField, bottomTxtField: bottomTextField, originalImageView: backgroundImageView)
        currentMeme.finalImage = generateMemedImage()
        finalImage = currentMeme.finalImage
       print("saving meme")
        toolBar.isHidden = false
        toolBarTop.isHidden = false
    }
    

    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    
    
    
    @IBAction func handleShareMemeBarButton(_ sender: Any) {
        
//        let items = ["This app is my favorite"]
//        let items = [URL(string: "https://www.apple.com")!]
        let items = [finalImage]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
        print("Share Button pressed")
    }
    
    
    
    

    
}


