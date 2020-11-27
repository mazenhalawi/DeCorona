//
//  StatusModels.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation
//FEATURES -> [{ATTRIBUTES -> StatusResponse}]
struct StatusResponse : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case statusSet = "features"
    }
    
    fileprivate let statusSet:[StatusAttributes]
    var statusList:[Status] {
        get {
            return statusSet.map({$0.status})
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusSet = try container.decodeIfPresent([StatusAttributes].self, forKey: .statusSet) ?? []
    }
}

fileprivate struct StatusAttributes : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case attributes = "attributes"
    }
    
    let status: Status
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Status.self, forKey: .attributes)
    }
}

struct Status : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case location = "county"
        case cases = "cases"
        case casesPer100k = "cases_per_100k"
        case deaths = "deaths"
        case deathRate = "death_rate"
        case lastUpdate = "last_update"
    }
    
    let location: String
    let cases: Int
    let casesPer100k: Int
    let deaths: Int
    let lastUpdate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        location = try container.decode(String.self, forKey: .location)
        cases = try container.decode(Int.self, forKey: .cases)
        
        let dblCases100k = try container.decode(Double.self, forKey: .casesPer100k)
        if let cases100k = Int(exactly: dblCases100k.rounded()) {
            casesPer100k = cases100k
        } else {
            throw Err.RuntimeError("Failed to decode cases_per_100k value from received dictionary")
        }
        
        deaths = try container.decode(Int.self, forKey: .deaths)
        lastUpdate = try container.decode(String.self, forKey: .lastUpdate)
    }
}
