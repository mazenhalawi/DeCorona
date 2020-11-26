//
//  NotificationPermissionCoordinator.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class NotificationPermissionCoordinator : NavigationCoordinator {
    
    var navigationController: UINavigationController
    var nextScene: (()->Void)?
    
    init(navigationController: UINavigationController, nextScene: (()->Void)? = nil) {
        self.navigationController = UINavigationController()
        self.nextScene = nextScene
    }
    
    func start() {
        let presenter = NotificationPermissionPresenter(coordinator: self)
        let vc = NotificationPermissionVC(presenter: presenter)
        presenter.output = vc
        navigationController.setViewControllers([vc], animated: false)
    }
    
    
}

extension NotificationPermissionCoordinator : NotificationPermissionCoorindatorInput {
    func finish() {
        nextScene?()
    }
    
    
}
