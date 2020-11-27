//
//  ConnectionManager.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import Foundation


class ConnectionManager {
    
    var sessionConfiguration:URLSessionConfiguration {
        get {
            let config = URLSessionConfiguration.default
            config.allowsCellularAccess = true
            config.allowsExpensiveNetworkAccess = true
            config.waitsForConnectivity = false
            config.timeoutIntervalForRequest = TimeInterval(exactly: 5)!
            config.timeoutIntervalForResource = TimeInterval(exactly: 5)!
        
            return config
        }
    }
    
    let baseURL = "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=1%3D1&outFields=death_rate,cases,deaths,cases_per_100k,cases_per_population,county,last_update,cases7_per_100k,recovered&inSR=4326&spatialRel=esriSpatialRelIntersects&returnGeometry=false&returnDistinctValues=true&f=json&geometryType=esriGeometryEnvelope"
    
    
    
    func queryLatestCoronaStatusFor(latitude: Double, longitude: Double, completionHandler: @escaping (Result<Data>) -> Void) {
        let newLatitude = latitude + 0.01
        let newLongitude = longitude + 0.01
        
        let geometry = "&geometry=\(latitude),\(longitude),\(newLatitude),\(newLongitude)"
        let urlString = baseURL + geometry
        guard let url = URL(string: urlString) else {
            fatalError("ConnectionManager - queryLatestCoronaStatusFor method failed with bad URL")
        }
        
        URLSession.init(configuration: sessionConfiguration).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(Result<Data>(status: ResultStatus.Failure, error: error.localizedDescription))
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    return completionHandler(Result<Data>(status: .Success, data: data))
                } else {
                    print("ConnectionManager - queryLatestCoronaStatusFor method returned no data")
                }
            }
            return completionHandler(Result<Data>(status: .Failure, error: ERROR_DEFAULT))
        }.resume()
    }
}
