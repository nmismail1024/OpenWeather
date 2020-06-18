//
//  OneCallForecastDataViewModel.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/21.
//  Copyright © 2020 NMI. All rights reserved.
//


import Foundation

public class OneCallForecastDataViewModel: SharedWeatherDataViewModel {
    
    private var oneCallForecastData: OneCallForecastData?
    public var forecast8Day: [DailyTemp] = []   //Current day + next 7 days

    public override init() {
        self.oneCallForecastData = nil
    }

    public init(oneCallForecastData: OneCallForecastData?) {
        self.oneCallForecastData = oneCallForecastData
    }
    
    //Call the api to get the weather data!
    public func getOneCallForecastData(completion: @escaping (_ success: Bool) -> Void = { success in }) {
        if let lat = self.lat, let lon = self.lon {
            openWeatherMapAPI.getOneCallForecastDataFromLatLong(lat: lat, lon: lon, units: self.tempUnits.rawValue) { oneCallForecastData in
                self.oneCallForecastData = oneCallForecastData
                self.forecast8Day = self.getForecast8day()  //We calc this once and cache it, so that we don't need to redo it each time!

                //print("oneCallForecastData = \(oneCallForecastData!)")
                //print("forecast8Day = \(forecast8Day!)")

                let success = (oneCallForecastData != nil)
                completion(success)    //***
            }
        } else {
            print("Error: Location not set. Unable to retrieve onecall data!")
        }
    }
    
    public func hasData() -> Bool {
        return oneCallForecastData != nil
    }
    
    //Return a default value if oneCallForecastData not set, alternatively we could use "oneCallForecastData!." and rather cause a runtime error when called!
    public var temp: Double {
        return oneCallForecastData?.current.temp ?? 0
    }
    
    public var tempLabelText: String {
        return formatTemperature(temp: temp)
    }

    private func getForecast8day() -> [DailyTemp] {
        return oneCallForecastData?.daily.map {
            let forecastType = self.forecastType(forecast: $0.weather.first?.main.uppercased() ?? "")
            let tempFormatted = self.formatTemperature(temp: $0.temp.day)
            
            return DailyTemp(dt: $0.dt, forecastType: forecastType, temp: $0.temp.day, tempFormatted: tempFormatted)
        } ?? []
    }
    
    //TODO Add other methods that may be needed here...
}
