//
//  LocationManager.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager : NSObject {
    
    private let manager:CLLocationManager
    
    static let current:LocationManager = LocationManager()
    
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
}
