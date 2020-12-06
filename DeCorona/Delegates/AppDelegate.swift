//
//  AppDelegate.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerBackgroundTask()
        
        NotificationManager.shared.start()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func registerBackgroundTask() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.syslynx.statusupdate", using: nil) { (task) in
            
            task.expirationHandler = {
                print("background task failed")
                task.setTaskCompleted(success: false)
            }
            
            self.refreshAppContent(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleAppTasks() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
        scheduleAppRefresh()
    }
    
    private func scheduleAppRefresh() {
        
        let request = BGAppRefreshTaskRequest(identifier: "com.syslynx.statusupdate")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch (let error) {
            print("AppDelegate - scheduleAppRefresh: " + error.localizedDescription)
        }
    }
    
    private func refreshAppContent(task: BGTask) {
        
            guard
                let location = LocationManager.current.currentLocation,
                let notifyServiceEnabled = NotificationManager.shared.notificationStatusUpdate$.value,
                notifyServiceEnabled
            else {
                print("AppDelegate - User has not permitted Location and Notification services")
                task.setTaskCompleted(success: true)
                    return
            }
        
            ConnectionManager().queryLatestCoronaStatusFor(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (result) in

                if let data = result.data,
                    result.status == .Success,
                    let decoded = try? JSONDecoder().decode(StatusResponse.self, from: data),
                    decoded.statusList.count > 0 {

                    let newStatus = decoded.statusList.first(where: {$0.location.hasPrefix("SK ")}) ?? decoded.statusList.first!
                    let saved = UserDefaults.standard.data(forKey: LAST_SAVED_STATUS)

                    let savedStatus = try? JSONDecoder().decode(Status.self, from: saved ?? Data())

                    //If saved record already exist
                    if let savedStatus = savedStatus {

                        if savedStatus == newStatus {
                            print("Same location and status - no changes")
                        } else if savedStatus.didStatusChange(from: newStatus) {
                            //TODO: Send notification to user
                            NotificationManager.shared.notifyUserOfStatusChange()
                        }

                    } else {

                        NotificationManager.shared.notifyUserOfStatusChange()
                    }

                    task.setTaskCompleted(success: true)

                } else {
                    print("AppDelegate - ConnectionManager returned unsuccessful.")
                    task.setTaskCompleted(success: true)
                }
            }
    }
}

