//
//  AppManager.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class AppManager {
    
    var window:UIWindow!
    private var baseNavController:UINavigationController
    
    static var shared = AppManager()
    
    private init() {
        baseNavController = UINavigationController()
    }
    
    func start(initialWindow : UIWindow) {
        self.window = initialWindow
        self.window.rootViewController = baseNavController
        
        let visits = UserDefaults.standard.integer(forKey: KEY_VISIT_COUNT)
        if (visits == 0) {
            showLocationPermissionScene()
            UserDefaults.standard.set(visits + 1, forKey: KEY_VISIT_COUNT)
        } else {
            showStatusScene()
        }
    }
    
    func showLocationPermissionScene() {
        let coordinator = LocationPermissionCoordinator(navigationController: UINavigationController(), nextScene: showNotificationPermissionScene)
        coordinator.start()
        baseNavController.setNavigationBarHidden(true, animated: false)
        baseNavController.pushViewController(
            coordinator.navigationController.topViewController!, animated: false)
    }
    
    func showNotificationPermissionScene() {
        let coordinator = NotificationPermissionCoordinator(navigationController: UINavigationController(), nextScene: showStatusScene)
        coordinator.start()
        baseNavController.setNavigationBarHidden(true, animated: false)
        baseNavController.pushViewController(coordinator.navigationController.topViewController!, animated: true)
    }
    
    func showStatusScene() {
        let coordinator = StatusCoordinator(navigationController: UINavigationController())
        coordinator.start()
        baseNavController.setNavigationBarHidden(true, animated: false)
        baseNavController.pushViewController(coordinator.navigationController.topViewController!, animated: true)
    }
}
