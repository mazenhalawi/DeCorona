//
//  StatusPresenter.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation
import Combine

class StatusPresenter {
    private weak var output:StatusPresenterOutput?
    private let interactor: StatusInteractorInput
    private var watcher: Cancellable?
    private var currentStatus:Status?
    
    var isLocationEnabled: Bool {
        return LocationManager.current.isLocationServiceEnabled()
    }
    
    var numOfRows: Int {
        return 0
    }
    
    init(interactor: StatusInteractorInput) {
        self.interactor = interactor
    }
    
    deinit {
        watcher?.cancel()
    }
}

extension StatusPresenter : StatusInteractorOutput {
    
    func displayStatusUpdate(response: Result<[Status]>) {
        if response.status == .Success && response.data != nil {
            let statusList = response.data!
            
            if statusList.count == 0 {
                self.output?.alert(title: "No Data Found", message: "No data found for your current location. Please try again later.")
                
            } else {
                let status = statusList.first(where: {$0.location.hasPrefix("SK ")}) ?? statusList.first!
                self.currentStatus = status
                self.output?.updateUI()
            }
            
            
        } else {
            self.output?.alert(title: "Failure", message: response.error ?? ERROR_DEFAULT)
        }
    }
}

extension StatusPresenter : StatusPresenterInput {
    
    func getLatestStatusUpdate() {
        
        if !LocationManager.current.isLocationServiceEnabled() {
            output?.alertLocationServiceDisabled()
            return
        }
        
        if let currentLocation = LocationManager.current.currentLocation {
            
            self.interactor.downloadLatestStatusUpdate(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude)
            
        } else {
            
            watcher = LocationManager.current.locationUpdate$.sink(receiveCompletion: { [weak self] (error) in
                
                self?.output?.alert(title: "Failure", message: "Failed to detect your location. Please try again later.")
                self?.output?.dismissSpinners()
                
            }) { [weak self] (location) in
                
                self?.interactor.downloadLatestStatusUpdate(
                                            latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
                self?.output?.dismissSpinners()
            }
            
            LocationManager.current.findCurrentUserLocation()
            
        }
    }

}


