//
//  NotificationPermissionVC.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class NotificationPermissionVC: UIViewController {

    var presenter:NotificationPermissionPresenterInput!
    
    convenience init(presenter: NotificationPermissionPresenterInput) {
        self.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnEnableNotification(_ sender: UIButton) {
        presenter.enableNotifications()
    }
    
    @IBAction func btnSkipAndContinue(_ sender: UIButton) {
        presenter.skipAndContinue()
    }

}

extension NotificationPermissionVC : NotificationPermissionPresenterOutput {
    
}
