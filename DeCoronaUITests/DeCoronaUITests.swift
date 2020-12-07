//
//  DeCoronaUITests.swift
//  DeCoronaUITests
//
//  Created by Mazen on 12/07/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import XCTest

class DeCoronaUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
//        let app = XCUIApplication()
//        app.children(matching: .window).element.tap()
//        app.alerts["Allow “DeCorona” to access your location?"].scrollViews.otherElements.buttons["Allow Once"].tap()
                
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
