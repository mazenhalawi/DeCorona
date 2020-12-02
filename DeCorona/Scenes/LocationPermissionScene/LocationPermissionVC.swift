//
//  LocationPermissionVC.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class LocationPermissionVC: UIViewController {
    
    var presenter:LocationPermissionPresenterInput!
    
    convenience init(presenter: LocationPermissionPresenterInput) {
        self.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func btnEnableLocation(_ sender: UIButton) {
        presenter.enableLocationServices()
    }
    
    @IBAction func btnSkipAndContinue(_ sender: UIButton) {
        presenter.skipAndContinue()
    }
    
}

extension LocationPermissionVC : LocationPermissionPresenterOutput {
    
    func alert(title: String, message: String, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(vc: self,
                                    title: title,
                                    message: message,
                                    actions: actions,
                                    style: UIAlertController.Style.alert)
        }
    }
}
