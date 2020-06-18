//
//  OneCallForecastDataModel.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/21.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation

public struct OneCallForecastData: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    let daily: [Daily]

    public struct Current: Codable {
        let dt: Int64
        let sunrise: Int64
        let sunset: Int64
        let temp: Double
        let weather: [Weather]
    }
    
    public struct Daily: Codable {
        let dt: Int64
        let sunrise: Int64
        let sunset: Int64
        let temp: Temp
        let weather: [Weather]
    }
    
    public struct Temp: Codable {
        let day: Double
        let min: Double
        let max: Double
    }
}

public struct DailyTemp {
    let dt: Int64
    let forecastType: SharedWeatherDataViewModel.ForecastType
    let temp: Double
    let tempFormatted: String
}
