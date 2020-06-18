//
//  OpenWeatherUITests.swift
//  OpenWeatherUITests
//
//  Created by Nur Ismail on 2020/05/15.
//  Copyright © 2020 NMI. All rights reserved.
//

import XCTest

extension XCUIApplication {
    
    var isDisplayingMainView: Bool {
        return otherElements["mainView"].exists
    }
}

class OpenWeatherUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShowingMainView() {
        // Launch app
        app.launch()
        
        // Make sure we're displaying main view
        XCTAssertTrue(app.isDisplayingMainView)
    }
    
    func testLocationNameLabel() {
        // Launch app
        app.launch()
        
        // Make sure we're displaying main view
        XCTAssertTrue(app.isDisplayingMainView)
        
        sleep(2)    // Short delay so that the update of label values reflect correctly in the test
        
        //NOTE: These values based on data returned from an api call. So if data changes on the backend then these tests might fail!
        XCTAssertEqual(app.staticTexts["locationNameLabel"].label, "San Francisco")
    }

    func testTempLabels() {
        // Launch app
        app.launch()
        
        // Make sure we're displaying dashboard view
        XCTAssertTrue(app.isDisplayingMainView)
        
        sleep(2)    // Short delay so that the update of label values reflect correctly in the test
        
        //NOTE: These values based on data returned from an api call. So if data changes on the backend then these tests might fail!
        XCTAssertEqual(app.staticTexts["tempLabel"].label, "19\u{00B0}")    //degrees
        
        XCTAssertEqual(app.staticTexts["minTempLabel"].label, "14\u{00B0}")    //degrees
        XCTAssertEqual(app.staticTexts["currTempLabel"].label, "19\u{00B0}")    //degrees
        XCTAssertEqual(app.staticTexts["maxTempLabel"].label, "23\u{00B0}")    //degrees
    }
    
    //TODO Add additional tests here...
}
