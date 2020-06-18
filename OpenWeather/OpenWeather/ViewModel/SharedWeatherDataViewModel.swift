//
//  SharedWeatherDataModel.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/21.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation

public class SharedWeatherDataViewModel {
    
    public enum BackgroundTheme {
        case forest
        case sea
    }
    
    public enum TemperatureUnits: String {
        case celcius = "metric"
        case farenheit = "imperial"
    }
    
    public enum ForecastType: String {
        case cloudy = "CLOUDY"
        case rainy = "RAINY"
        case sunny = "SUNNY"
    }

    //---
    typealias BackImageInfo = (imageName: String, backHexColor: String)
    
    let themeConfig: Dictionary<BackgroundTheme, Dictionary<ForecastType, BackImageInfo>> =
        [.forest: [.cloudy: (imageName: "forest_cloudy", backHexColor: "#54717A"),
                    .rainy: (imageName: "forest_rainy", backHexColor: "#57575D"),
                    .sunny: (imageName: "forest_sunny", backHexColor: "#47AB2F")],
         
            .sea: [.cloudy: (imageName: "sea_cloudy", backHexColor: "#628594"),
                    .rainy: (imageName: "sea_rainy", backHexColor: "#57575D"),
                    .sunny: (imageName: "sea_sunny", backHexColor: "#468FE4")]
    ]
    
    let forecastIconImage: Dictionary<ForecastType, String> =
        [.cloudy: "partlysunny",
          .rainy: "rain",
          .sunny: "clear"]

    var theme: BackgroundTheme = .sea
    var tempUnits: TemperatureUnits = .celcius

    //---
    var lat: Double? = nil
    var lon: Double? = nil

    public func setLocation(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    public func setUnits(units: TemperatureUnits) {
        self.tempUnits = units
    }
    
    public func setTheme(theme: BackgroundTheme) {
        self.theme = theme
    }
    
    public func forecastType(forecast: String) -> ForecastType {
        //TODO Not an exhaustive list, since the OpenWeatherMap api documention is a bit vague of all the values to expect here, and we only have limited set of background images!
        switch (forecast) {
        case "CLOUDS": return .cloudy
        case "RAIN": return .rainy
        default: return .sunny
        }
    }

    public var forecastType: ForecastType {
        return forecastType(forecast: "")
    }
    
    public var backgroundImageName: String {
        return themeConfig[theme]![forecastType]!.imageName
    }
    
    public var backgroundHexColor: String {
        return themeConfig[theme]![forecastType]!.backHexColor
    }

    public func formatTemperature(temp: Double) -> String {
        return "\(Int(round(temp)))\u{00B0}"    //rounded temperature + degree symbol
    }

}
