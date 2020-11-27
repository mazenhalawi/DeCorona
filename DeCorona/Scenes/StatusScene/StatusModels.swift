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
        print("step 1")
        self.statusSet = try container.decode([StatusAttributes].self, forKey: .statusSet)
    }
}

fileprivate struct StatusAttributes : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case attributes = "attributes"
    }
    
    let status: Status
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        print("step 2")
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
        
        print("step 3")
        location = try container.decode(String.self, forKey: .location)
        print("step 4")
        cases = try container.decode(Int.self, forKey: .cases)
        print("step 5")
        let dblCases100k = try container.decode(Double.self, forKey: .casesPer100k)
        print("step 6")
        if let cases100k = Int(exactly: dblCases100k.rounded()) {
            print("step 7")
            casesPer100k = cases100k
        } else {
            print("step 8")
            throw Err.RuntimeError("Failed to decode cases_per_100k value from received dictionary")
        }
        print("step 9")
        deaths = try container.decode(Int.self, forKey: .deaths)
        print("step 10")
        lastUpdate = try container.decode(String.self, forKey: .lastUpdate)
    }
}
