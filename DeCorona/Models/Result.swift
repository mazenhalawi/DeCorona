//
//  Result.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation


struct Result<T> {
    let status: ResultStatus
    let data: T?
    let error: String?
    
    init(status: ResultStatus, data: T? = nil, error: String? = nil) {
        self.status = status
        self.data = data
        self.error = error
    }
}
