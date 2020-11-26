//
//  StatusCoordinator.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class StatusCoordinator : NavigationCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let interactor = StatusInteractor()
        let presenter = StatusPresenter(interactor: interactor, coordinator: self)
        let vc = StatusVC(presenter: presenter)
        presenter.output = vc
    
        navigationController.setViewControllers([vc], animated: false)
    }
    
    
}

extension StatusCoordinator : StatusCoordinatorInput {
    
}
