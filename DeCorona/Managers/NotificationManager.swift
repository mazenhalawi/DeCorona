//
//  NotificationManager.swift
//  DeCorona
//
//  Created by Mazen on 12/02/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationManager : NSObject {
    
    let center = UNUserNotificationCenter.current()
    
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    lazy var notificationSettings = center.getNotificationSettings
    
    func requestUserPermission() {
        
        center.requestAuthorization(options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { (status, error) in
            if let _ = error {
                print(error!.localizedDescription)
            }
            print(status)
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func notifyUserOfLocationChange() {
        
        let content = UNMutableNotificationContent()
        content.title = "Corona Status Update"
        content.subtitle = "Location change updates"
        content.body = "It seems you have moved into another location. Check the updated directions for the current location."
        content.categoryIdentifier = CATEGORY_LOC_CHANGE
        content.threadIdentifier = CATEGORY_LOC_CHANGE
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension NotificationManager : UNUserNotificationCenterDelegate {
    
    //Notification received while app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    //User's response to delivered notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    //Display user notification settings
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print(notification?.date.description)
    }
    
}
