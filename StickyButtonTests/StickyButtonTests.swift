//
//  StickyButtonTests.swift
//  StickyButtonTests
//
//  Created by Achref Marzouki on 25/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import XCTest
@testable import StickyButton

class StickyButtonTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWindow() {
        let stickyButton = StickyButton(size: 60)
        stickyButton.isOpen = true
        let stickyVc = StickyButtonViewController()
        stickyVc.stickyButton = stickyButton
        let window = StickyButtonWindow(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        window.rootViewController = stickyVc
        
        let insidePoint = CGPoint(x: 100, y: 100)
        var isInside = window.point(inside: insidePoint, with: nil)
        XCTAssert(isInside)
        
        stickyButton.isOpen = false
        let outsidePoint = CGPoint(x: 500, y: 100)
        isInside = window.point(inside: outsidePoint, with: nil)
        XCTAssert(!isInside)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
