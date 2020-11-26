//
//  NavigationCoordinator.swift
//  DeCorona
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

protocol NavigationCoordinator {
    var navigationController:UINavigationController { get set}
    func start()
}
