//
//  ViewController.swift
//  Weather
//
//  Created by mac on 20.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var timeStrings = [String(), String(), String(), String()]
    var iconImages = [UIImage(), UIImage(), UIImage(), UIImage()]
    var temperatureStrings = [String(), String(), String(), String()]
    
    let locationManager = CLLocationManager()
    let hud = MBProgressHUD()
    var openWeather = OpenWeatherMap()
    
    @IBAction func selectCityAction(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Go out back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Set background
        let background = UIImage(named: "background")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
        //Set setup
        self.openWeather.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCity() {
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
            if let textField = alert.textFields?.first {
                self.activityIndicator()
                self.openWeather.weatherFor(city: textField.text!)
            }
        }
        alert.addAction(ok)
        
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    // MARK: OpenWeatherMapDelegate
    func updateWeatherInfo(weatherJson: JSON) {
        hud.hide(animated: true)
        print(weatherJson)
        
        if let temperatureResult = weatherJson["list"][0]["main"]["temp"].float {
            //Get country
            let country = weatherJson["city"]["country"].stringValue
            
            //Get city name
            let cityName = weatherJson["city"]["name"].stringValue
            self.cityNameLabel.text = "\(cityName), \(country)"
            
            //Get time
            let now = Int(Date().timeIntervalSince1970)
            let timeToString = openWeather.timeFromUnix(unixTime: now)
            self.timeLabel.text = "At \(timeToString) it is"
            
            //Get counvert temperature
            let temperature = openWeather.convertTemperature(country: country, temperature: temperatureResult)
            self.temperatureLabel.text = "\(temperature)º"
            
            //Get icon
            let weather = weatherJson["list"][0]["weather"][0]
            let condition = weather["id"].intValue
            let iconString = weather["icon"].stringValue
            let nightTime = openWeather.isTimeNight(icon: iconString)
            openWeather.updateWeatherIcon(condition: condition, nightTime: nightTime, index: 0, weatherIcon: self.updateIconList)
            //self.iconImageView.image = icon
            
            //Get description
            let description = weather["description"].stringValue
            self.descriptionLabel.text = description
            
            //Get speed wind
            let speedWind = weatherJson["list"][0]["wind"]["speed"].doubleValue
            self.speedWindLabel.text = "\(speedWind)"
            
            //Get humidity
            let humidity = weatherJson["list"][0]["main"]["humidity"].intValue
            self.humidityLabel.text = "\(humidity)"
            
            for index in 1...4 {
                if let temperatureResult = weatherJson["list"][index]["main"]["temp"].float {
                    //Get counvert temperature
                    let temperature = openWeather.convertTemperature(country: country, temperature: temperatureResult)
                    
                    temperatureStrings[index - 1] = "\(temperature)"
                    
                    //Get forecast time
                    let forecastTime = weatherJson["list"][index]["dt"].intValue
                    let timeString = openWeather.timeFromUnix(unixTime: forecastTime)
                    
                    timeStrings[index - 1] = "\(timeString)"
                    
                    //Get icon
                    let weather = weatherJson["list"][index]["weather"][0]
                    let iconString = weather["icon"].stringValue
                    let nightTime = openWeather.isTimeNight(icon: iconString)
                    openWeather.updateWeatherIcon(condition: condition, nightTime: nightTime, index: index, weatherIcon: self.updateIconList)
                } else {
                    continue
                }
            }
            
        } else {
            print("Unable load weather info")
        }
    }
    
    func updateIconList(_ index: Int, _ name: String) {
        switch index {
        case 0: self.iconImageView.image = UIImage(named: name)
        case 1...4: iconImages[index - 1] = UIImage(named: name)!
        default: break
        }
    }
    
    func failure() {
        // No connection to internet
        let networkController = UIAlertController(title: "Error", message: "No connection!", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        networkController.addAction(ok)
        
        present(networkController, animated: true, completion: nil)
        hud.hide(animated: true)
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location!)
        
        self.activityIndicator()
        let currentLocation = locations.last!
        
        if currentLocation.horizontalAccuracy > 0 {
            //Stopping updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.openWeather.weatherFor(geo: coords)
            print(coords)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location")
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            let forecastViewController = segue.destination as! ForecastViewController
            
            var index = 0
            for timeString in timeStrings {
                forecastViewController.timeStrings[index] = timeString
                index += 1
            }
            
            index = 0
            for iconImage in iconImages {
                forecastViewController.iconImages[index] = iconImage
                index += 1
            }
            
            index = 0
            for temperatureString in temperatureStrings {
                forecastViewController.temperatureStrings[index] = temperatureString
                index += 1
            }
        }
    }
}
