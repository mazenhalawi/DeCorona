//
//  StatusProtocols.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation


protocol StatusInteractorInput {
    func downloadLatestStatusUpdate(latitude: Double, longitude: Double)
}

protocol StatusInteractorOutput : class {
    func displayStatusUpdate(response: Result<[Status]>)
}

protocol StatusPresenterInput {
    func getLatestStatusUpdate()
    func requestNotificationPermission()
    func refreshNotificationAuthorization()
    var isLocationEnabled: Bool? { get }
    var numOfRows: Int { get }
    func contentForCell(at indexPath: IndexPath) -> String
    var location: String { get }
    var coordinates: String { get }
    var casesPer100k: String { get }
    var cases: String { get }
    var deaths: String { get }
    var deathRate: String { get }
    var lastUpdated: String { get }
    var condition: StatusCondition { get }
}

protocol StatusPresenterOutput : class {
    func alert(title: String, message: String)
    func alertLocationServiceDisabled()
    func dismissSpinners()
    func updateUI()
    func toggleNotificationButton(on: Bool)
}
