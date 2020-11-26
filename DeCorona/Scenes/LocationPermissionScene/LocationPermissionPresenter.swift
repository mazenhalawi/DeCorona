//
//  LocationPermissionPresenter.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

class LocationPermissionPresenter {
    var output:LocationPermissionPresenterOutput?
    fileprivate let coordinator:LocationPermissionCoordinatorInput
    
    init(coordinator: LocationPermissionCoordinatorInput) {
        self.coordinator = coordinator
    }
    
}

extension LocationPermissionPresenter : LocationPermissionPresenterInput {
    func enableLocationServices() {
        LocationManager.current.requestPermission()
    }
    
    func skipAndContinue() {
        coordinator.finish()
    }
}
