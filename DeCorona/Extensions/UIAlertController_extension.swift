//
//  UIAlertController_extension.swift
//  DeCorona
//
//  Created by Mazen on 11/27/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit


extension UIAlertController {
    
    static func showAlert(vc: UIViewController, title: String, message: String, actions: [UIAlertAction]? = nil, style: UIAlertController.Style! = .alert) {
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions == nil ?
            alert.addAction(defaultAction) : alert.addActions(actions: actions!)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func addActions(actions: [UIAlertAction]) {
        actions.forEach({self.addAction($0)})
    }
}
