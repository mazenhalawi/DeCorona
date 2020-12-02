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
    weak var output:StatusPresenterOutput?
    private let interactor: StatusInteractorInput
    private var watcher: Cancellable?
    private var currentStatus:Status?
    
    var isLocationEnabled: Bool? {
        return LocationManager.current.isLocationServiceEnabled()
    }
    
    var numOfRows: Int {
        return condition.directions.count
    }
    
    init(interactor: StatusInteractorInput) {
        self.interactor = interactor
    }
    
    deinit {
        watcher?.cancel()
    }
    
    private func startLocationWatcher() {
        watcher = LocationManager.current.locationUpdate$.sink(receiveCompletion: { [weak self] (error) in
            
            self?.output?.alert(title: "Failure", message: "Failed to detect your location. Please try again later.")
            self?.output?.dismissSpinners()
            
        }) { [weak self] (location) in
            
            self?.interactor.downloadLatestStatusUpdate(
                                        latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude)
            self?.output?.dismissSpinners()
        }
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
    
    var condition:StatusCondition {
        get {
            guard let status = currentStatus else { return StatusCondition.Null }
            return StatusCondition(statusLevel: status.casesPer100k)
        }
    }
    
    var casesPer100k: String {
        get {
            guard let cases100k = currentStatus?.casesPer100k else { return "" }
            return String(describing: cases100k)
        }
    }
    
    var cases: String {
        get {
            guard let cases = currentStatus?.cases else { return "" }
            return String(describing: cases)
        }
    }
    
    var coordinates: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 4
            
            guard let coordinates = LocationManager.current.currentLocation?.coordinate,
                let lat = numberFormatter.string(from: NSNumber(value: coordinates.latitude)),
                let lon = numberFormatter.string(from: NSNumber(value: coordinates.longitude))
            else { return "" }
            
            return lat + ", " + lon
        }
    }
    
    var deaths: String {
        get {
            guard let deaths = currentStatus?.deaths else { return "" }
            return String(describing: deaths)
        }
    }
    
    var deathRate: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            guard let deathRate = currentStatus?.deathRate,
                let rate = numberFormatter.string(from: NSNumber(value: deathRate))
            else { return "" }
            
            return rate.appending("%")
        }
    }
    
    var lastUpdated: String {
        get {
            guard let updatedOn = currentStatus?.lastUpdate,
                let date = updatedOn.components(separatedBy: ", ").first
            else { return "" }
            
            return date
        }
    }
    
    var location: String {
        get {
            var loc:String = ""
            if let serviceEnabled = LocationManager.current.isLocationServiceEnabled() {
                loc = serviceEnabled ? "Undetermined" : "Service Disabled"
            }
            return currentStatus?.location.replacingOccurrences(of: "SK ", with: "").replacingOccurrences(of: "LK ", with: "") ?? loc
        }
    }
    
    func getLatestStatusUpdate() {
        
        let serviceEnabled:Bool? = LocationManager.current.isLocationServiceEnabled()
        
        //LocationService is Undetermined
        if serviceEnabled == nil {
            LocationManager.current.requestPermission()
            startLocationWatcher()
            
        //LocationService was denied
        } else if serviceEnabled == false {
            
            output?.alertLocationServiceDisabled()
            return
        }
        
        //LocationService is enabled
        if let currentLocation = LocationManager.current.currentLocation {
            
            self.interactor.downloadLatestStatusUpdate(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude)

        } else {
            
            self.startLocationWatcher()
            LocationManager.current.findCurrentUserLocation()
            
        }
    }
    
    func contentForCell(at indexPath: IndexPath) -> String {
        return self.condition.directions[indexPath.row]
    }

}


