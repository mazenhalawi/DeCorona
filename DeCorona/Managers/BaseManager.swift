//
//  Manager.swift
//  DeCorona
//
//  Created by Mazen on 12/03/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class BaseManager : NSObject {
    
    override init() {
        super.init()
    }
    
    func openAppSettings() throws {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            throw Err.RuntimeError("BaseManager - openAppSettings: Settings URL caused an error.")
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            throw Err.RuntimeError("BaseManager - openAppSettings: UIApplication could not open url")
        }
    }
    
    func start() {}
    
}
