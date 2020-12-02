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
        NotificationManager.shared.requestUserPermission()
    }
    
    func skipAndContinue() {
        coordinator.finish()
    }
    
    
}
