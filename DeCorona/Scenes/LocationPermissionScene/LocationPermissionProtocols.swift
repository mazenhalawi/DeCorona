//
//  LocationPermissionProtocols.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

protocol LocationPermissionCoordinatorInput {
    func finish()
}

protocol LocationPermissionPresenterInput : class {
    func enableLocationServices()
    func skipAndContinue()
}

protocol LocationPermissionPresenterOutput {
    
}
