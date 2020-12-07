//
//  StatusSceneUITest.swift
//  DeCoronaUITests
//
//  Created by Mazen on 12/07/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import XCTest

class StatusSceneUITest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUIUpdateFromAPIData() {
        let expect = expectation(description: "ALLOW_LOCATION")
        
        let app = XCUIApplication()
        let window = app.children(matching: .window)
        XCTAssertNotNil(window)
        
        addUIInterruptionMonitor(withDescription: "Location Service") { (alert) -> Bool in
            let button = alert.buttons["Allow Once"]
            XCTAssertNotNil(button)
            button.tap()
            expect.fulfill()
            return true
        }
        app.tap()
        
        waitForExpectations(timeout: 5)
    
        let tblDirections = window.tables.firstMatch
        XCTAssertNotNil(tblDirections)
        
        expectation(for: NSPredicate(format: "cells.count > 0"), evaluatedWith: tblDirections)
        waitForExpectations(timeout: 8)
        
        
        let lblCasesPer100k = app.staticTexts["lblCasesPer100k"]
        XCTAssertNotNil(lblCasesPer100k)
        
        let casesPer100k = Int(lblCasesPer100k.label)
        XCTAssertNotNil(casesPer100k)
        XCTAssertTrue(casesPer100k! > 100)
        
        if casesPer100k! > 100 {
            XCTAssertTrue(tblDirections.cells.count == 2)
        } else if casesPer100k! > 0 && casesPer100k! <= 100 {
            XCTAssertTrue(tblDirections.cells.count == 3)
        } else {
            XCTAssertTrue(tblDirections.cells.count == 0)
        }
        
        let lblLocation = app.staticTexts["lblLocation"]
        XCTAssertNotNil(lblLocation)
        XCTAssertTrue(lblLocation.label.count > 0)
        
        let lblCoordinates = app.staticTexts["lblCoordinates"]
        XCTAssertNotNil(lblCoordinates)
        XCTAssertTrue(lblCoordinates.label.count > 0)
        
        let lblCases = app.staticTexts["lblCases"]
        XCTAssertNotNil(lblCases)
        XCTAssertTrue(lblCases.label.count > 0)
        
        let lblDeaths = app.staticTexts["lblDeaths"]
        XCTAssertNotNil(lblDeaths)
        XCTAssertTrue(lblDeaths.label.count > 0)
        
        let lblDeathRate = app.staticTexts["lblDeathRate"]
        XCTAssertNotNil(lblDeathRate)
        XCTAssertTrue(lblDeathRate.label.count > 0)
        
        let lblLastUpdated = app.staticTexts["lblLastUpdated"]
        XCTAssertNotNil(lblLastUpdated)
        XCTAssertTrue(lblLastUpdated.label.count > 0)
    }

}
