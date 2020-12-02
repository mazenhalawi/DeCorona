//
//  LocationManager.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager : NSObject {
    
    private let manager:CLLocationManager
    private var _currentLocation:CLLocation? {
        didSet {
            locationUpdate$.send(self._currentLocation!)
        }
    }
    
    let locationUpdate$ = PassthroughSubject<CLLocation, Error>()
    
    static let current:LocationManager = LocationManager()
    
    var currentLocation:CLLocation? {
        get {
            return _currentLocation
        }
    }
    
    override private init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        if (isLocationServiceEnabled() ?? false) {
            manager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func isLocationServiceEnabled() -> Bool? {
        let status = CLLocationManager.authorizationStatus()
        switch (status) {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined: return nil
        default: return false
        }
    }
    
    func requestPermission() {
        manager.requestAlwaysAuthorization()
    }
    
    func findCurrentUserLocation() {
        
        if let serviceEnabled = isLocationServiceEnabled(),
            serviceEnabled == true {
            return
        }
        manager.startMonitoringSignificantLocationChanges()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startMonitoringSignificantLocationChanges()
        case .notDetermined:
            requestPermission()
        default:
            print("User has disabled location services")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let sortedLocations = locations.sorted { $0.timestamp > $1.timestamp }
        if let firstLocation = sortedLocations.first {
            self._currentLocation = firstLocation
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager - didFailWithError Failed to find location")
        locationUpdate$.send(completion: .failure(error))
    }
    
}
