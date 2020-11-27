//
//  StatusPresenter.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

class StatusPresenter {
    weak var output:StatusPresenterOutput?
    let interactor: StatusInteractorInput
    let coordinator: StatusCoordinatorInput
    
    var isLocationEnabled: Bool {
        return LocationManager.current.isLocationServiceEnabled()
    }
    
    var numOfRows: Int {
        return 1
    }
    
    init(interactor: StatusInteractorInput, coordinator: StatusCoordinatorInput) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
}

extension StatusPresenter : StatusPresenterInput {
    func getLatestStatusUpdate() {
        
    }

}


