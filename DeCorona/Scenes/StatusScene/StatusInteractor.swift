//
//  StatusInteractor.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

class StatusInteractor {
    weak var output: StatusInteractorOutput?
}

extension StatusInteractor : StatusInteractorInput {
    
    func downloadLatestStatusUpdate(latitude: Double, longitude: Double) {
        ConnectionManager().queryLatestCoronaStatusFor(latitude: latitude, longitude: longitude) { [weak self] (result: Result<Data>) in
            
            if let data = result.data, result.status == ResultStatus.Success {

                let decoded = try? JSONDecoder().decode(StatusResponse.self, from: data)
                if decoded == nil {
                    
                    print("StatusInteractor - downloadLatestStatusUpdate could not decode data from API")
                    self?.output?.displayStatusUpdate(response: Result(status: .Failure, error: "SERVER_DATA_ERR".localize()))
                    
                } else {
                    
                    self?.output?.displayStatusUpdate(response: Result(status: .Success, data: decoded!.statusList))
                }
                
            } else {
                
                self?.output?.displayStatusUpdate(response: Result(status: .Failure, error: result.error))
            }
        }
    }
    
}
