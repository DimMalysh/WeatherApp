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
    
    let locationManager = CLLocationManager()
    var openWeather = OpenWeatherMap()
    let hud = MBProgressHUD()
    
    @IBAction func cityButtonTapped(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        if let temperatureResult = weatherJson["main"]["temp"].float {
            //Get country
            let country = weatherJson["sys"]["country"].stringValue
            
            //Get city name
            let cityName = weatherJson["name"].stringValue
            print(cityName)
            
            //Get counvert temperature
            let temperature = openWeather.convertTemperature(country: country, temperature: temperatureResult)
            print(temperature)
            
            //Get icon
            let weather = weatherJson["weather"][0]
            let condition = weather["id"].intValue
            let nightTime = openWeather.isTimeNight(weatherJson: weatherJson)
            let icon = openWeather.updateWeatherIcon(condition: condition, nightTime: nightTime)
            self.iconImageView.image = icon
            
        } else {
            print("Unable load weather info")
        }
    }
    
    func failure() {
        // No connection to internet
        let networkController = UIAlertController(title: "Error", message: "No connection!", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        networkController.addAction(ok)
        
        present(networkController, animated: true, completion: nil)
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
}
