//
//  LocationPermissionCoordinator.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit


class LocationPermissionCoordinator : NavigationCoordinator  {
    
    var navigationController: UINavigationController
    fileprivate var nextScene:()->()
    
    init(navigationController: UINavigationController, nextScene: @escaping ()->()) {
        self.navigationController = navigationController
        self.nextScene = nextScene
    }
    
    func start() {
        let presenter = LocationPermissionPresenter(coordinator: self)
        let vc = LocationPermissionVC(presenter: presenter)
        presenter.output = vc
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([vc], animated: false)
    }
    
}


extension LocationPermissionCoordinator : LocationPermissionCoordinatorInput {
    
    func finish() {
        nextScene()
    }
}
