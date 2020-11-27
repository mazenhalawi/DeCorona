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
                    self?.output?.displayStatusUpdate(response: Result(status: .Failure, error: "The data returned from the server is unrecognizable. Please try again."))
                    
                } else {
                    
                    let statusList = decoded!.statusList
                    
                    if statusList.count == 0 {
                        self?.output?.displayStatusUpdate(response: Result(status: .Failure, error: "No data found for the current location."))
                        
                    } else if statusList.count == 1 {
                        self?.output?.displayStatusUpdate(response: Result(status: .Success, data: statusList.first!))
                        
                    } else {
                        let selected = statusList.first(where: {$0.location.hasPrefix("SK ")})
                        self?.output?.displayStatusUpdate(response: Result(status: .Success, data: selected))
                    }
                    
                }
                
            } else {
                
                self?.output?.displayStatusUpdate(response: Result(status: .Failure, error: result.error))
            }
        }
    }
    
}
