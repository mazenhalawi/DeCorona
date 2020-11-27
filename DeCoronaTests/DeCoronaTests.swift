//
//  DeCoronaTests.swift
//  DeCoronaTests
//
//  Created by Mazen on 11/25/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import XCTest
@testable import DeCorona

class DeCoronaTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testQueryLatestCoronaStatusReturnsData() {
        let expect = expectation(description: "WEB_QRY")
        let latitude = 9.41266410790402
        let longitude = 54.8226409068342
        
        ConnectionManager().queryLatestCoronaStatusFor(latitude: latitude, longitude: longitude) { (result) in
            if result.status == .Success {
                XCTAssertNotNil(result.data as? Data)
                print(result.data!!)
                print("queryLatestCoronaStatusFor method completed successfully with Data")
            } else {
                print("queryLatestCoronaStatusFor method completed successfully without Data")
                print(result.error ?? "error raised")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: TimeInterval(exactly: 5)!) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func testJSONSerializationOfDataIntoStatusModel() {
        let expect = self.expectation(description: "JSON_SERIAL_TEST")
        let latitude = 9.41266410790402
        let longitude = 54.8226409068342
        
        ConnectionManager().queryLatestCoronaStatusFor(latitude: latitude, longitude: longitude) { (result) in
            if result.status == .Success {
                XCTAssertNotNil(result.data as? Data)
                let json = try? JSONDecoder().decode(StatusResponse.self, from: result.data!!)
                XCTAssertNotNil(json)
            } else {
                print(result.error ?? "error raised")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("expectation caught error")
                print(error.localizedDescription)
            }
        }
    }

}
