//
//  OpenWeatherTests.swift
//  OpenWeatherTests
//
//  Created by Nur Ismail on 2020/05/15.
//  Copyright © 2020 NMI. All rights reserved.
//

import XCTest
@testable import OpenWeather

class OpenWeatherTests: XCTestCase {
    let sampleWeatherDataJSON =
    """
    {"coord":{"lon":-122.41,"lat":37.79},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","main":{"temp":19.87,"feels_like":15.23,"temp_min":15.56,"temp_max":24.44,"pressure":1015,"humidity":53},"visibility":16093,"wind":{"speed":6.7,"deg":270},"clouds":{"all":20},"dt":1590106930,"sys":{"type":1,"id":5154,"country":"US","sunrise":1590065694,"sunset":1590117478},"timezone":-25200,"id":5391959,"name":"San Francisco","cod":200}
    """
    
    let useLiveData = false
    var sampleWeatherData: WeatherData? = nil
    
    // This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        
        if useLiveData {
            //Since this makes a live api call, and gets the current temperatures, so many of our UI tests will probably fail as they don't know what temperature to expect! Alternatively the UI tests should instead check that the temperatures conform to a valid value rather than checking for specific values!!!
            let model = WeatherDataViewModel()
            
            model.setLocation(lat: 37.79, lon: -122.41) //San Francisco
            model.getWeatherData() { success in
                self.sampleWeatherData = success ? model._weatherData : nil
            }
        } else {
            // Using a fixed json string here for testing purposes, but could instead do an actual api call!
            let jsonData = sampleWeatherDataJSON.data(using: .utf8)!
            
            sampleWeatherData = try? JSONDecoder().decode(WeatherData.self, from: jsonData)
        }
    }
    
    func testLocationNameValue() {
        let model = WeatherDataViewModel(weatherData: sampleWeatherData)
        
        XCTAssert(model.locationName == "San Francisco", "invalid locationName: '\(model.locationName)'")
    }

    func testTempMinValue() {
        let model = WeatherDataViewModel(weatherData: sampleWeatherData)
        
        XCTAssert(model.temp >= model.tempMin, "temp cannot be less than tempMin")
    }

    func testTempMaxValue() {
        let model = WeatherDataViewModel(weatherData: sampleWeatherData)
        
        XCTAssert(model.temp <= model.tempMax, "temp cannot be more than tempMax")
    }
    
    //TODO Add additional tests here...
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
