//
//  NotificationPermissionSceneUITest.swift
//  DeCoronaUITests
//
//  Created by Mazen on 12/07/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import XCTest

class NotificationPermissionSceneUITest: XCTestCase {

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

    func testAutomaticNavigationFromNotificationPermissionAfterInput() {
        
        let app = XCUIApplication()
        
        let reqLocButton = app.buttons["Enable Location"]
        XCTAssertTrue(reqLocButton.exists)

        reqLocButton.tap()
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            let btnAllow = alert.buttons["Allow Once"]
            XCTAssertNotNil(btnAllow)
            btnAllow.tap()
            return true
        }

        app.tap()
        
        let locLabel = app.children(matching: .window).containing(.staticText, identifier: "notifyPermissionLabelID").firstMatch
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: locLabel, handler: nil)
      
        waitForExpectations(timeout: 5)

    }

}
