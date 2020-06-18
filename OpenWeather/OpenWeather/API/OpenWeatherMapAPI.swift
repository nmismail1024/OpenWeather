//
//  OpenWeatherMapAPI.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/15.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation

public class OpenWeatherMapAPI {
    
    //Open Weather Map API Key. Change for different users.
    private let API_KEY = "90e53c0244e1be9bcf5423661a981ec9"
    
    //Open Weather Map URL prefix
    private let apiURLPrefix = "https://api.openweathermap.org/data/2.5/"
    
    //API calls
    public func getWeatherDataFromLatLong(lat: Double, lon: Double, units: String = "metric", completion: @escaping (WeatherData?) -> Void = { weatherData in }) {
        
        let apiCall = "weather?lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(self.API_KEY)&lang=en"
        let apiURL = URL(string: apiURLPrefix + apiCall)!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(apiURL.absoluteString)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //assume an error if data == nil
            guard data != nil else {
                completion(nil)
                return
            }
            
            //print(response!)  //debug info
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                //print("*** weatherData = \(weatherData)")
                
                completion(weatherData)  //***
            } catch {
                print("error")
                completion(nil)  //***
            }
        })
        
        task.resume()
    }
    
    //NOTE: Unable to use the usual '.../forecast?' or '.../forecast/daily?' api calls to get 5 day forecast, as it might be paid option, or not available anymore. However OWM's new 'onecall' api call, has ability to return 8 day forecast (current day + next 7 days) so we rather using that.
    public func getOneCallForecastDataFromLatLong(lat: Double, lon: Double, units: String = "metric", completion: @escaping (OneCallForecastData?) -> Void = { oneCallForecastData in }) {
        //We currently using this call for the 7 day forecast (actually returns 8 days, current day + next 7 days)
        //However it's lacking the location name for the daily forecast, so still using the usual daily weather api call!
        let apiCall = "onecall?lat=\(lat)&lon=\(lon)&units=\(units)&exclude=minutely,hourly&appid=\(self.API_KEY)&lang=en"
        let apiURL = URL(string: apiURLPrefix + apiCall)!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(apiURL.absoluteString)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //assume an error if data == nil
            guard data != nil else {
                completion(nil)
                return
            }
            
            //print(response!)  //debug info
            do {
                let oneCallForecastData = try JSONDecoder().decode(OneCallForecastData.self, from: data!)
                //print("*** oneCallForecastData = \(oneCallForecastData)")
                
                completion(oneCallForecastData)  //***
            } catch {
                print("error")
                completion(nil)  //***
            }
        })
        
        task.resume()
    }
}

public let openWeatherMapAPI = OpenWeatherMapAPI()
