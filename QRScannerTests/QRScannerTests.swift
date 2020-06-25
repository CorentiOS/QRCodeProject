//
//  QRScannerTests.swift
//  QRScannerTests
//
//  Created by Corentin Medina on 06/01/2020.
//  Copyright © 2020 Corentin Medina. All rights reserved.
//

import XCTest
@testable import QRScanner

class QRScannerTests: XCTestCase {
    
    func testInitCodeCadeau() {
        let codeTest = codeCadeau(code: "MCDO25", enddate: "08/05/2020", marchant: "Mcdonald's", qrcode: "dleenfnlm", startdate: "01/01/2020", value: "25%")
        
        XCTAssertEqual("MCDO25", codeTest.code)
        XCTAssertEqual("08/05/2020", codeTest.enddate)
        XCTAssertEqual("Mcdonald's", codeTest.marchant)
        XCTAssertEqual("dleenfnlm", codeTest.qrcode)
        XCTAssertEqual("01/01/2020", codeTest.startdate)
        XCTAssertEqual("25%", codeTest.value)
        
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
