//
//  StatusProtocols.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation


protocol StatusCoordinatorInput {
    
}

protocol StatusInteractorInput {
    func downloadLatestStatusUpdate(latitude: Double, longitude: Double)
}

protocol StatusInteractorOutput : class {
    func displayStatusUpdate(respose: Result<Status?>)
}

protocol StatusPresenterInput {
    func getLatestStatusUpdate()
    var isLocationEnabled: Bool { get }
    var numOfRows: Int { get }
}

protocol StatusPresenterOutput : class {
    func alert(title: String, message: String)
    func alertLocationServiceDisabled()
    func dismissSpinners()
    func showMainSpinner()
    func updateUI()
}
