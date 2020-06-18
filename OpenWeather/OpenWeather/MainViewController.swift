//
//  MainViewController.swift
//  OpenWeather
//
//  Created by Nur Ismail on 2020/05/15.
//  Copyright © 2020 NMI. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgWeatherType: UIImageView!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblForecast: UILabel!
    @IBOutlet weak var lblForecastMain: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblCurrTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var tempMinMaxView: UIView!
    @IBOutlet weak var btnSeaTheme: UIButton!
    @IBOutlet weak var btnForestTheme: UIButton!
    @IBOutlet weak var btnUseCelcius: UIButton!
    @IBOutlet weak var btnUseFarenheit: UIButton!
    @IBOutlet weak var tblForecast7Day: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var locationManager = CLLocationManager()
    private var allowRetry = false  //If set to true (after an error occurred) then the user can tap the main view to try to reload weather data.
    
    //View models
    private let weatherDataViewModel = WeatherDataViewModel()
    private let oneCallForecastDataViewModel = OneCallForecastDataViewModel()
    
    //Helper property to make it slightly easier to access the values in the model
    private var forecast8Day: [DailyTemp] {  //Current day + next 7 days
        return self.oneCallForecastDataViewModel.forecast8Day
    }

    //Error messages
    //TODO Possibly define in a separate localization file, to make localization easier
    private let unableToRetrieveDataErrorMsg = "Unable to retrieve Weather Data. Please check that you are connected to the internet."
    private let unableToRetrieveLocationErrorMsg = "Unable to retrieve location. Please check that you are connected to the internet."
    private let unableToRetrieveLocationPermissionErrorMsg = "Unable to retrieve location. Ensure the app has permission to access your location!"
    private let errorOccurredRetryErrorMsg = "Error occurred. Tap to retry!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblForecast7Day.delegate = self
        self.tblForecast7Day.dataSource = self

        view.accessibilityIdentifier = "mainView"
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        self.resetWeatherLabels()
        //self.retrieveWeather()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.retrieveWeather()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        //override status bar text colour to white
        return .lightContent
    }
    
    @objc private func handleTap() {
        if allowRetry {
            print("Tap. Retry.")
            allowRetry = false
            self.retrieveWeather()
        }
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecast8Day.count - 1 //-1 since we want to exclude the first day which represents the current day!
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: ForecastViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ForecastViewCell

        let index = indexPath.row + 1   //+1 since we want to skip over the first day which represents the current day!
        let forecast = self.forecast8Day[index]
        
        // set the text from the data model
        let df = DateFormatter()
        df.dateFormat = "EEEE"  //Day of Week (Long)
        cell.lblDayOfWeek.text = df.string(from: Date(timeIntervalSince1970: Double(forecast.dt)))
        cell.lblTemp.text = forecast.tempFormatted
        cell.backgroundColor = self.tblForecast7Day.backgroundColor
        
        let imageName = self.oneCallForecastDataViewModel.forecastIconImage[forecast.forecastType]
        cell.imgWeatherType.image = imageName != nil ? UIImage(named: imageName!) : nil
        return cell
    }
    
    private func retrieveWeather() {
        
        self.resetWeatherLabels()
        activityIndicatorView.startAnimating()
        
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            
            var currentLoc: CLLocation!
            currentLoc = locationManager.location
            if currentLoc != nil {
                let lat = currentLoc.coordinate.latitude
                let lon = currentLoc.coordinate.longitude
                
                print("current location: lat = \(lat), lon = \(lon)")
                weatherDataViewModel.setLocation(lat: lat, lon: lon)
                
                weatherDataViewModel.getWeatherData() { success in
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        
                        if (success) {
                            self.setWeatherLabels()
                        } else {
                            self.lblLocationName.text = self.errorOccurredRetryErrorMsg
                            self.allowRetry = true
                            self.alert(message: self.unableToRetrieveDataErrorMsg, title: "Error")
                        }
                    }
                }
                
                oneCallForecastDataViewModel.setLocation(lat: lat, lon: lon)
                
                oneCallForecastDataViewModel.getOneCallForecastData() { success in
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        
                        if (success) {
                            //self.tblForecast7Day.reloadData()
                            self.animateTable(tableView: self.tblForecast7Day)  //This also implicitely calls .reloadData() so we don't need it above!
                        } else {
                            self.lblLocationName.text = self.errorOccurredRetryErrorMsg
                            self.allowRetry = true
                            self.alert(message: self.unableToRetrieveDataErrorMsg, title: "Error")
                        }
                    }
                }

            } else {
                activityIndicatorView.stopAnimating()
                print("Unable to retrieve location!")
                self.lblLocationName.text = errorOccurredRetryErrorMsg
                self.allowRetry = true
                self.alert(message: self.unableToRetrieveLocationErrorMsg, title: "Error")
            }
        } else {
            activityIndicatorView.stopAnimating()
            print("Unable to retrieve location. Ensure app has permission to access your location!")
            self.lblLocationName.text = errorOccurredRetryErrorMsg
            self.allowRetry = true
            self.alert(message: self.unableToRetrieveLocationPermissionErrorMsg, title: "Error")
        }
    }
    
    private func resetWeatherLabels() {
        lblLocationName.text = ""
        lblTemperature.text = ""
        lblForecast.text = ""
        lblForecastMain.text = ""
        lblMinTemp.text = ""
        lblCurrTemp.text = ""
        lblMaxTemp.text = ""
    }

    private func setWeatherLabels() {
        //self.weatherDataViewModel.setTheme(theme: .forest)
        self.imgWeatherType.image = UIImage(named: self.weatherDataViewModel.backgroundImageName)
        self.tempMinMaxView.backgroundColor = UIColor.init(hex: self.weatherDataViewModel.backgroundHexColor)
        self.tblForecast7Day.backgroundColor = self.tempMinMaxView.backgroundColor

        self.lblLocationName.text =  self.weatherDataViewModel.locationName
        
        self.lblTemperature.text = self.weatherDataViewModel.tempLabelText
        self.lblForecast.text = self.weatherDataViewModel.forecastType.rawValue
        //self.lblForecastMain.text = self.weatherDataViewModel.forecastDescription

        self.lblMinTemp.text = self.weatherDataViewModel.tempMinLabelText
        self.lblCurrTemp.text = self.weatherDataViewModel.tempLabelText
        self.lblMaxTemp.text = self.weatherDataViewModel.tempMaxLabelText
        
        self.animateLabels()
    }
    
    private func animateLabels() {
        //Location name
        let offset = CGPoint(x: -self.view.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        self.lblLocationName.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.lblLocationName.isHidden = false
        
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.lblLocationName.transform = .identity
                self.lblLocationName.alpha = 1
        })
        
        //Temperature
        // make the label not visible and scale it to 0.5x
        self.lblTemperature.alpha = 0
        self.lblTemperature.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // Finally the animation!
        UIView.animate(
            withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.lblTemperature.transform = .identity
                self.lblTemperature.alpha = 1
        }, completion: nil)
        
        //Forecast
        self.lblForecast.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.lblForecast.alpha = 1
        }, completion: nil)
    }
    
    private func animateTable(tableView: UITableView) {
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    private func setButtonsTitleFont(buttonActive: UIButton, buttonNormal: UIButton) {
        //Makes the 'active' button's title font bold, else normal
        let fontNameActive = "Avenir-Heavy"
        let fontNameNormal = "Avenir-Light"
        
        buttonActive.titleLabel?.font = UIFont(name: fontNameActive, size: 14.0)
        buttonNormal.titleLabel?.font = UIFont(name: fontNameNormal, size: 14.0)
    }
    
    @IBAction func btnSeaThemePressed(_ sender: UIButton) {
        self.weatherDataViewModel.setTheme(theme: .sea)
        self.oneCallForecastDataViewModel.setTheme(theme: .sea)
        
        self.setButtonsTitleFont(buttonActive: btnSeaTheme, buttonNormal: btnForestTheme)
        self.retrieveWeather()
    }
    
    @IBAction func btnForestThemePressed(_ sender: UIButton) {
        self.weatherDataViewModel.setTheme(theme: .forest)
        self.oneCallForecastDataViewModel.setTheme(theme: .forest)
        
        self.setButtonsTitleFont(buttonActive: btnForestTheme, buttonNormal: btnSeaTheme)
        self.retrieveWeather()
    }
    
    @IBAction func btnUseCelciusPressed(_ sender: UIButton) {
        self.weatherDataViewModel.setUnits(units: .celcius)
        self.oneCallForecastDataViewModel.setUnits(units: .celcius)
        
        self.setButtonsTitleFont(buttonActive: btnUseCelcius, buttonNormal: btnUseFarenheit)
        self.retrieveWeather()
    }
    
    @IBAction func btnUseFarenheitPressed(_ sender: UIButton) {
        self.weatherDataViewModel.setUnits(units: .farenheit)
        self.oneCallForecastDataViewModel.setUnits(units: .farenheit)
        
        self.setButtonsTitleFont(buttonActive: btnUseFarenheit, buttonNormal: btnUseCelcius)
        self.retrieveWeather()
    }
    
}
