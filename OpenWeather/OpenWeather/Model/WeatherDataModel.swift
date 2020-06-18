//
//  WeatherDataModel.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/17.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation

public struct WeatherData: Codable {
    let main: MainWeather
    let name: String
    let coord: CoOrd
    //let country: String
    let weather: [Weather]
}

public struct MainWeather: Codable {
    let feels_like: Double
    let humidity: Double
    let pressure: Double
    let temp: Double
    let temp_max: Double
    let temp_min: Double
}

public struct CoOrd: Codable {
    let lat: Double
    let lon: Double
}

public struct Weather: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}
