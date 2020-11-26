//
//  NotificationPermissionPresenter.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

class NotificationPermissionPresenter {
    weak var output: NotificationPermissionPresenterOutput?
    let coordinator: NotificationPermissionCoorindatorInput
    
    init(coordinator: NotificationPermissionCoorindatorInput) {
        self.coordinator = coordinator
    }
    
}

extension NotificationPermissionPresenter : NotificationPermissionPresenterInput {
    
    func enableNotifications() {
        print("create a notification manager and enable notification")
    }
    
    func skipAndContinue() {
        coordinator.finish()
    }
    
    
}
