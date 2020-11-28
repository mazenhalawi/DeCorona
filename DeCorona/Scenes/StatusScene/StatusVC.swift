//
//  StatusVC.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class StatusVC: UIViewController {
    @IBOutlet weak var containerBackground:UIView!
    @IBOutlet weak var spinnerMain:UIActivityIndicatorView!
    
    private var presenter: StatusPresenterInput!
    private var index = 0
    private var didOpenSettings = false
    
    convenience init(presenter: StatusPresenterInput) {
        self.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if didOpenSettings {
            if presenter.isLocationEnabled {
                spinnerMain.startAnimating()
                presenter.getLatestStatusUpdate()
            }
            didOpenSettings = false
        } else {
            spinnerMain.startAnimating()
            presenter.getLatestStatusUpdate()
        }
        
    }
    
    private func changeBackground() {
        let green = UIColor.init(red: 6/255, green: 149/255, blue: 14/255, alpha: 1.0)
        let red = UIColor.init(red: 159/255, green: 9/255, blue: 10/255, alpha: 1.0)
        let yellow = UIColor.init(red: 193/255, green: 169/255, blue: 11/255, alpha: 1.0)

        let colors = [red, yellow, green]

        UIView.animate(withDuration: 2) {
            self.containerBackground.backgroundColor = colors[self.index]
            self.containerBackground.alpha = 0.9
        }

        index += 1
        if index >= colors.count { index = 0; }
    }
    
    @objc private func pullDownRefresh() {
        presenter.getLatestStatusUpdate()
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { [weak self] (success) in
                self?.didOpenSettings = success
            })
        }
    }
}

extension StatusVC : StatusPresenterOutput {
    
    func updateUI() {
//        DispatchQueue.main.async { [weak self] in
//
//        }
    }
    
    func dismissSpinners() {
        DispatchQueue.main.async { [weak self] in
            self?.spinnerMain.stopAnimating()
        }
    }
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIAlertController.showAlert(vc: self,
            title: title,
            message: message)
        }
    }
    
    func alertLocationServiceDisabled() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIAlertController.showAlert(vc: self,
                                        title: "Location Required",
                                        message: "You have disabled location services. We require your current location to fetch relevant data. Would you like to enable the service now?",
                                        actions: [
                                            UIAlertAction(title: "No",
                                                      style: .destructive),
                                            UIAlertAction(title: "Yes",
                                                      style: .default,
                                                      handler: { [weak self] (_) in self?.openSettings();
                                                        
                                            })
                                        ])
        }
    }
    
}


