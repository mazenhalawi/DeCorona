//
//  UIView_extension.swift
//  DeCorona
//
//  Created by Mazen on 11/28/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit


extension UIView {
    
    @IBInspectable var roundedCorners:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.shadowOffset = CGSize.zero
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor:UIColor? {
        get {
            guard let _ = self.layer.shadowColor else { return nil }
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue!.cgColor
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity:Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset:CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        get {
            guard let _ = self.layer.borderColor else { return nil }
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
