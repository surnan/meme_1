//
//  ViewController.swift
//  Meme_1
//
//  Created by admin on 11/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


class MemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var backgroundImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.backgroundColor = UIColor.black
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var topTextField: UITextField = {
       var textField = UITextField()

        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.clearsOnBeginEditing = true
        
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.6
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        
        let memeText = NSMutableAttributedString(string: "TOP", attributes: memeTextAttributes)
        textField.attributedText = memeText
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    var bottomTextField: UITextField = {
        var textField = UITextField()
        
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.clearsOnBeginEditing = true
        
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.6
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        
        let memeText = NSMutableAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
        textField.attributedText = memeText
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func setupTextFieldAndBackgroundImage(){
        [backgroundImageView].forEach{view.addSubview($0)}
        [topTextField, bottomTextField].forEach{backgroundImageView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
    
    //MARK: Local Defined Variables
    var topToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barTintColor = UIColor.lightGray
        toolbar.isTranslucent = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var bottomToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barTintColor = UIColor.lightGray
        toolbar.isTranslucent = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    
    //MARK:- ImagePickerController Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            backgroundImageView.image = editedImage  //if the image is cropped or moved by user
        } else if let originalImage = info[.originalImage] as? UIImage {
            backgroundImageView.image = originalImage //if user does nothing after selecting photo
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI_and_Contraints(){
        setupTopToolBar()
        setupBottomToolBar()

        [topToolbar, bottomToolbar].forEach{backgroundImageView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            topToolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
    
    //MARK:- Make Meme Functions
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func saveMeme()-> Meme {
        showToolbars(makeVisible: false)
        let currentMeme = Meme(topTxtField: topTextField,
                               bottomTxtField: bottomTextField,
                               originalImageView: backgroundImageView,
                               memeImage: generateMemedImage())
        showToolbars(makeVisible: true)
        return currentMeme
    }


    //MARK:- Swift Overload Functions
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
        setupTextFieldAndBackgroundImage()
        setupUI_and_Contraints()
        [topTextField, bottomTextField].forEach{
            $0.addTarget(self, action: #selector(myTextFieldTextChanged), for: UIControl.Event.editingChanged)
            $0.delegate = self
        }
    }
}
