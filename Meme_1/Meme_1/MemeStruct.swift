//
//  MemeObject.swift
//  Meme_1
//
//  Created by admin on 11/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

struct Meme {
    var top: String
    var bottom: String
    var originalImage: UIImage
    var finalImage: UIImage
    
    
    init(topTxtField: UITextField, bottomTxtField: UITextField, originalImageView: UIImageView) {
        self.top = topTxtField.text!
        self.bottom = bottomTxtField.text!
        
        if let image = originalImageView.image {
            self.originalImage = image
        } else {
            self.originalImage = UIImage()
        }
        self.finalImage = UIImage()
    }
    
    init(topTxtField: UITextField, bottomTxtField: UITextField, originalImageView: UIImageView, memeImage: UIImage) {
        self.top = topTxtField.text!
        self.bottom = bottomTxtField.text!
        self.finalImage = memeImage
        
        if let image = originalImageView.image {
            self.originalImage = image
        } else {
            self.originalImage = UIImage()
        }
    }
}
