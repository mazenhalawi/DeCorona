//
//  NotificationPresenterProtocols.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

protocol NotificationPermissionCoorindatorInput {
    func finish()
}

protocol NotificationPermissionPresenterInput {
    func enableNotifications()
    func skipAndContinue()
}

protocol NotificationPermissionPresenterOutput : class {
    
}


