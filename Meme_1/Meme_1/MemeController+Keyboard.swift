//
//  MemeController+Keyboard.swift
//  Meme_1
//
//  Created by admin on 11/15/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension MemeController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing == true {
            view.frame.origin.y = -getKeyboardHeight(notification)  // y=0 top of screen. We shift it upwards
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    //notifcations used to push the boundary of screen bottom above the keyboard.
    //Without this, the keyboard covers the bottom textfield even though you're putting data in there when typing
    //func keyboardWillShow === boundary change
    
    func subscribeToKeyboardNotification(){
        print("subscribe")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification(){
        print("--UNsubscribe---")
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            return keyboardSize.height
        }
        return 0.0
    }
}
