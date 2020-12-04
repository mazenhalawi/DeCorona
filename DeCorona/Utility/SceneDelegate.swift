//
//  SceneDelegate.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        registerBackgroundTask()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.makeKeyAndVisible()
        
        AppManager.shared.start(initialWindow: self.window!)
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name.init(KEY_APP_ACTIVE), object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        scheduleAppRefresh()
    }

    private func registerBackgroundTask() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.syslynx.appRefresh", using: nil) { (task) in
    
            print("registering background task")
            
            task.expirationHandler = {
                print("background task failed")
                task.setTaskCompleted(success: false)
            }
            
            print("testing service enabling")
            guard let locationServiceEnabled = LocationManager.current.isLocationServiceEnabled(),
                let notifyServiceEnabled = NotificationManager.shared.notificationStatusUpdate$.value,
                locationServiceEnabled,
                notifyServiceEnabled
            else {
                print("SceneDelegate - User has not permitted Location and Notification services")
                task.setTaskCompleted(success: true)
                    return
            }
            
            print("finding location")
            let _ = LocationManager.current.locationUpdate$.sink(receiveCompletion: { (error) in
                print("SceneDelegate - Location manager raised an error.")
                
            }) { (location) in
                print("Location found now fetching data")
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
                                print("User is still in the same location")
                            } else if savedStatus.didStatusChange(from: newStatus) {
                                //TODO: Send notification to user
                                NotificationManager.shared.notifyUserOfStatusChange()
                            }
                            
                        } else {
                            
                            NotificationManager.shared.notifyUserOfStatusChange()
                        }
                        
                        task.setTaskCompleted(success: true)
                        
                    } else {
                        print("SceneDelegate - ConnectionManager returned unsuccessful.")
                        task.setTaskCompleted(success: true)
                    }
                }
            }
            
            LocationManager.current.forceFindUserLocation()
        }
    }
    
    func scheduleAppRefresh() {
        
        let request = BGProcessingTaskRequest(identifier: "com.syslynx.appRefresh")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("submitted task request")
        } catch (let error) {
            print("SceneDelegate - scheduleAppRefresh: " + error.localizedDescription)
        }
    }

}

