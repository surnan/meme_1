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
    
    func showToolbars(makeVisible: Bool){
        if !makeVisible {
            bottomToolbar.isHidden = true
            topToolbar.isHidden = true
        } else {
            topToolbar.isHidden = false
            bottomToolbar.isHidden = false
        }
    }
    
    //MARK:- Toolbars programiticallly
    var topToolbar: UIToolbar = {
       var toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barTintColor = UIColor.red
        toolbar.isTranslucent = false
        return toolbar
    }()
    
    var bottomToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barTintColor = UIColor.red
        toolbar.isTranslucent = false
        return toolbar
    }()
    
    func setupUI_and_Contraints(){
        setupTopToolBar()
        setupBottomToolBar()
        [topToolbar, bottomToolbar].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
        topToolbar.topAnchor.constraint(equalTo: view.topAnchor),
        topToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        topToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        bottomToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
        bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupTopToolBar(){
        let barButtonOne = UIBarButtonItem(title: "SHARE", style: .done, target: self, action: #selector(handleShareBarButton))
        let barButtonTwo = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(helloWorld))
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        
        topToolbar.setItems([barButtonOne, flexibleSpace ,barButtonTwo], animated: false)
    }

    func setupBottomToolBar(){
        let barButtonOne = UIBarButtonItem(title: "PICK", style: .done, target: self, action: #selector(handleAlbumBarButton))
        let barButtonTwo = UIBarButtonItem(title: "CAMERA", style: .plain, target: self, action: #selector(handleCameraBarButton))
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        
        bottomToolbar.setItems([flexibleSpace, barButtonOne, flexibleSpace ,barButtonTwo,flexibleSpace], animated: false)
    }
    
    @objc func handleAlbumBarButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleCameraBarButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)    }
    
    
    @objc private func helloWorld(){
        print("hello world")
    }
    
    @objc private func handleShareBarButton() {
        saveMeme()
        let items = [finalImage]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        print("--Share Button pressed--")
    }
    
    
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
        view.backgroundColor = UIColor.black

        setupUI_and_Contraints()
        
        
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
    
    func saveMeme() {
        showToolbars(makeVisible: false)
        var currentMeme = Meme(topTxtField: topTextField, bottomTxtField: bottomTextField, originalImageView: backgroundImageView)
        currentMeme.finalImage = generateMemedImage()
        finalImage = currentMeme.finalImage
        showToolbars(makeVisible: true)
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}


