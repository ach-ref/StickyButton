//
//  StickyButtonExampleUITests.swift
//  StickyButtonExampleUITests
//
//  Created by Achref Marzouki on 26/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import XCTest

class StickyButtonExampleUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // portrait orientation
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testTheButtons() {
        // launch the application
        app = XCUIApplication()
        app.launch()
        
        let stickyButton = app.buttons["Sticky Button"]
        XCTAssert(stickyButton.exists)
        stickyButton.tap()
        let homeButton = stickyButton.buttons["Home"]
        XCTAssert(homeButton.exists)
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
