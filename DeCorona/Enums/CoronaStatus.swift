//
//  CoronaStatus.swift
//  DeCorona
//
//  Created by Mazen on 11/29/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation

enum StatusCondition {
    case Green
    case Yellow
    case Red
    case Null
    
    
    init(statusLevel: Int) {
        switch statusLevel {
        case let level where level > 0 && level < 35: self = StatusCondition.Green
        case let level where level <= 50: self = StatusCondition.Yellow
        case let level where level > 50: self = StatusCondition.Red
        default: self = StatusCondition.Null
        }
    }
    
    var directions:[String] {
        switch self {
        case .Green: return DIRECTIONS_GREEN
        case .Yellow: return DIRECTIONS_YELLOW
        case .Red: return DIRECTIONS_RED
        case .Null: return []
        }
    }
}
