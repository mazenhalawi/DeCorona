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
    }
    
    func isLocationServiceEnabled() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch (status) {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default: return false
        }
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func findCurrentUserLocation() {
        if (!isLocationServiceEnabled()) { return }
        
        manager.requestLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager status fired")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("user has enabled location services")
        case .notDetermined:
            requestPermission()
        default:
            print("user has disabled location services")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations count: " + locations.count.description)
        if let firstLocation = locations.first {
            print("latitude: " + firstLocation.coordinate.latitude.description + "  longitude: " + firstLocation.coordinate.longitude.description)
            self._currentLocation = firstLocation
            locationUpdate$.send(firstLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager - didFailWithError Failed to find location")
        locationUpdate$.send(completion: .failure(error))
    }
}
