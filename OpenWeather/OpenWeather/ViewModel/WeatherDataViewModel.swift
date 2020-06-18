//
//  WeatherDataViewModel.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/17.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation

public class WeatherDataViewModel: SharedWeatherDataViewModel {

    private var weatherData: WeatherData?

    public override init() {
        self.weatherData = nil
    }

    public init(weatherData: WeatherData?) {
        self.weatherData = weatherData
    }
    
    //Call the api to get the weather data!
    public func getWeatherData(completion: @escaping (_ success: Bool) -> Void = { success in }) {
        if let lat = self.lat, let lon = self.lon {
            openWeatherMapAPI.getWeatherDataFromLatLong(lat: lat, lon: lon, units: self.tempUnits.rawValue) { weatherData in
                self.weatherData = weatherData
                //print("weatherData = \(weatherData!)")
                
                let success = (weatherData != nil)
                completion(success)    //***
            }
        } else {
            print("Error: Location not set. Unable to retrieve weather data!")
        }
    }
    
    public func hasData() -> Bool {
        return weatherData != nil
    }

    //Return a default value if weatherData not set, alternatively we could use "weatherData!." and rather cause a runtime error when called!
    public var temp: Double {
        return weatherData?.main.temp ?? 0
    }

    public var tempMin: Double {
        return weatherData?.main.temp_min ?? 0
    }
    
    public var tempMax: Double {
        return weatherData?.main.temp_max ?? 0
    }
    
    public var tempLabelText: String {
        return formatTemperature(temp: temp)
    }
    
    public var tempMinLabelText: String {
        return formatTemperature(temp: tempMin)
    }
    
    public var tempMaxLabelText: String {
        return formatTemperature(temp: tempMax)
    }

    public var locationName: String {
        return weatherData?.name ?? ""
    }
    
    public var forecastMain: String {
        return weatherData!.weather.first?.main.uppercased() ?? ""
    }
    
    public var forecastDescription: String {
        //return weatherData!.weather.first(where: { ($0.id == 500) || ($0.id == 501) })?.description.uppercased() ?? ""
        return weatherData!.weather.first?.description.uppercased() ?? ""
    }

    public override var forecastType: ForecastType {
        return forecastType(forecast: forecastMain)
    }

    public var _weatherData: WeatherData? { //Useful to have access to this data during Unit Tests, etc.
        return self.weatherData
    }
    
    //TODO Add other methods that may be needed here...
}
