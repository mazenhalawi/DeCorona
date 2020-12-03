//
//  LocationPermissionPresenter.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation
import Combine

class LocationPermissionPresenter {
    var output:LocationPermissionPresenterOutput?
    fileprivate let coordinator:LocationPermissionCoordinatorInput
    
    private var _cancellable: Cancellable?
    
    init(coordinator: LocationPermissionCoordinatorInput) {
        self.coordinator = coordinator
    }
    
    deinit {
        _cancellable?.cancel()
    }
    
}

extension LocationPermissionPresenter : LocationPermissionPresenterInput {
    func enableLocationServices() {
    
        if let serviceEnabled = LocationManager.current.isLocationServiceEnabled()  {
            
            if serviceEnabled{
                self.coordinator.finish()
            } else {
                LocationManager.current.requestPermission()
            }
            
        } else {
            _cancellable = LocationManager.current.locationUpdate$.sink(receiveCompletion: { (error) in
                self.output?.alert(title: "TITLE_LOC_ERROR".localize(),
                                   message: "MSG_LOC_ERROR".localize(),
                                   actions: nil)
            }, receiveValue: { (location) in
                self.coordinator.finish()
            })
            LocationManager.current.requestPermission()
        }
    }
    
    func skipAndContinue() {
        coordinator.finish()
    }
}
