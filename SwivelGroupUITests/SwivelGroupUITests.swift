//
//  SwivelGroupUITests.swift
//  SwivelGroupUITests
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import XCTest

class SwivelGroupUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--SwivelGroup UI Testing")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func test_btnRegisterDisplays(){
//        XCTAssertTrue(app.buttons["Register"].exists)
//    }
//    
//    func test_incompleteFormAlertDisplays(){
//        app.buttons["Register"].tap()
//        XCTAssertTrue(app.alerts.element.staticTexts["Field Can't be empty"].exists)
//    }
//
//    func test_invalidEmailAlertDisplays(){
//        app.buttons["Register"].tap()
//        XCTAssertTrue(app.alerts.element.staticTexts["Please enter valid email"].exists)
//    }
//    
//    func test_invalidMobileAlertDisplays(){
//        app.buttons["Register"].tap()
//        XCTAssertTrue(app.alerts.element.staticTexts["Please enter valid mobile no"].exists)
//    }
//    
//    func test_btnBitcoinDisplays(){
//        XCTAssertTrue(app.buttons["bitcoin"].exists)
//    }
//    
//    func test_btnAppleDisplays(){
//        XCTAssertTrue(app.buttons["apple"].exists)
//    }
//    
//    func test_btnEarthquakeDisplays(){
//        XCTAssertTrue(app.buttons["earthquake"].exists)
//    }
//    
//    func test_btnAnimalDisplays(){
//        XCTAssertTrue(app.buttons["animal"].exists)
//    }
    
}
