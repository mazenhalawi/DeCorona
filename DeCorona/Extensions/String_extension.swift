//
//  String_extension.swift
//  DeCorona
//
//  Created by Mazen on 12/03/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

extension String {
    
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}
