//
//  ViewController.swift
//  Meme_1
//
//  Created by admin on 11/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


class MemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Outlet Variables
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField! {
        didSet{
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
        [topToolbar, bottomToolbar].forEach{view.addSubview($0)}
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
        setupUI_and_Contraints()
        [topTextField, bottomTextField].forEach{$0.addTarget(self, action: #selector(myTextFieldTextChanged), for: UIControl.Event.editingChanged)}
    }
}


