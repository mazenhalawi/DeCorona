//
//  LocationPermissionProtocols.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

protocol LocationPermissionCoordinatorInput {
    func finish()
}

protocol LocationPermissionPresenterInput : class {
    func enableLocationServices()
    func skipAndContinue()
}

protocol LocationPermissionPresenterOutput {
    func alert(title: String, message: String, actions: [UIAlertAction]?)
}
