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
                
                let status = try? JSONDecoder().decode(Status.self, from: data)
                if status == nil {
                    
                    print("StatusInteractor - downloadLatestStatusUpdate could not decode data from API")
                    self?.output?.displayStatusUpdate(respose: Result(status: .Failure, error: "The data returned from the server is unrecognizable. Please try again."))
                    
                } else {
                    
                    self?.output?.displayStatusUpdate(respose: Result(status: .Success, data: status))
                }
                
            } else {
                
                self?.output?.displayStatusUpdate(respose: Result(status: .Failure, error: result.error))
            }
        }
    }
    
}
