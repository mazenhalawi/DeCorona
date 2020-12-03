//
//  NotificationPermissionPresenter.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation
import Combine

class NotificationPermissionPresenter {
    weak var output: NotificationPermissionPresenterOutput?
    let coordinator: NotificationPermissionCoorindatorInput
    var notificationUpdateSubscription:Cancellable?
    
    init(coordinator: NotificationPermissionCoorindatorInput) {
        self.coordinator = coordinator
        
        notificationUpdateSubscription = NotificationManager.shared.notificationStatusUpdate$.sink(receiveValue: { (isEnabled) in
            if let _ = isEnabled {
                DispatchQueue.main.async {
                    self.notificationUpdateSubscription?.cancel()
                    self.coordinator.finish()
                }
            }
        })
    }
    
    deinit {
        notificationUpdateSubscription?.cancel()
    }
    
}

extension NotificationPermissionPresenter : NotificationPermissionPresenterInput {
    
    func enableNotifications() {
        NotificationManager.shared.requestUserPermission()
    }
    
    func skipAndContinue() {
        notificationUpdateSubscription?.cancel()
        coordinator.finish()
    }
    
    
}
