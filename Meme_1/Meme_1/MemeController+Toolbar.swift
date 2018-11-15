//
//  MemeController+Toolbar.swift
//  Meme_1
//
//  Created by admin on 11/15/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension MemeController {
    
    //MARK:- Both Toolbars
    func showToolbars(makeVisible: Bool){
        if !makeVisible {
            bottomToolbar.isHidden = true
            topToolbar.isHidden = true
        } else {
            topToolbar.isHidden = false
            bottomToolbar.isHidden = false
        }
    }
    
    //MARK:- TOP Toolbars
    func setupTopToolBar(){
        let barButtonOne = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShareBarButton))
        let barButtonTwo = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(handleCancelBarButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,target: nil,action: nil)
        topToolbar.setItems([barButtonOne, flexibleSpace ,barButtonTwo], animated: false)
    }
    
    @objc func handleShareBarButton() {
        let currentMeme = saveMeme()
        let items = [currentMeme.finalImage]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc func handleCancelBarButton() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        backgroundImageView.image = UIImage()
    }
    
    //MARK:- BOTTOM Toolbars
    func setupBottomToolBar(){
        let myImage = #imageLiteral(resourceName: "camera2")
        let barButtonOne = UIBarButtonItem(image: myImage, style: .plain, target: self, action: #selector(handleCameraBarButton))
        let barButtonTwo = UIBarButtonItem(title: "Album", style: .done, target: self, action: #selector(handleAlbumBarButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,target: nil,action: nil)
        //Camera check for enabling BarButtonTwo
        barButtonOne.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) ? true : false
        bottomToolbar.setItems([flexibleSpace, barButtonOne, flexibleSpace ,barButtonTwo,flexibleSpace], animated: false)
    }
    
    @objc func handleAlbumBarButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleCameraBarButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}
