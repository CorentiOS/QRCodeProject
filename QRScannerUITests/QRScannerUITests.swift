//
//  QRScannerUITests.swift
//  QRScannerUITests
//
//  Created by Corentin Medina on 10/03/2020.
//  Copyright © 2020 Corentin Medina. All rights reserved.
//

import XCTest

class QRScannerUITests: XCTestCase {

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
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.buttons["History"].tap()
        sleep(1)
        app.buttons["Scan"].tap()
        sleep(1)
        app.buttons["History"].tap()
        sleep(1)
        app.cells.element(boundBy: 0).tap()
        sleep(1)
        app.buttons["My History"].tap()
        XCTAssertEqual(1, app.cells.count)
        sleep(1)
        app.cells.element(boundBy: 0).tap()
        sleep(1)
        app.buttons["Copy my code"].tap()
        let content = UIPasteboard.general.string
        XCTAssertEqual("MCDO25", content)
        sleep(1)
        app.buttons["My History"].tap()
        sleep(1)
        app.cells.element(boundBy: 0).swipeLeft()
        sleep(1)
        app.cells.element(boundBy: 0).buttons["Delete"].tap()
        XCTAssertEqual(0, app.cells.count)
        
        
        
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
