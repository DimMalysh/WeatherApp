//
//  OpenWeatherMap.swift
//  Weather
//
//  Created by mac on 20.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import CoreLocation

protocol OpenWeatherMapDelegate {
    func updateWeatherInfo(weatherJson: JSON)
    func failure()
}

class OpenWeatherMap {
    let weatherUrl = "http://api.openweathermap.org/data/2.5/forecast"
    
    var delegate: OpenWeatherMapDelegate!
    
    func weatherFor(city: String) {
        let parameters = ["q" : city, "appid" : "4e63f48bb2d090d7fb7d80f6447ace6a"]
        setRequest(parameters: parameters)
    }
    
    func weatherFor(geo: CLLocationCoordinate2D) {
        let parameters: [String : Any] = ["lat" : geo.latitude, "lon" : geo.longitude, "appid" : "4e63f48bb2d090d7fb7d80f6447ace6a"]
        setRequest(parameters: parameters)
    }
    
    func setRequest(parameters: [String : Any]?) {
        request(weatherUrl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.error != nil {
                self.delegate.failure()
            } else {
                let weatherJson = JSON(response.value!)
                
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo(weatherJson: weatherJson)
                }
            }
        }
    }
    
    func timeFromUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: weatherDate)
    }
    
    func updateWeatherIcon(condition: Int, nightTime: Bool, index: Int, weatherIcon:(_ index: Int, _ name: String) -> ()) {
        
        switch (condition, nightTime) {
        //Thunderstorm
        case let (x, y) where x < 300 && y == true:  weatherIcon(index, "11n")
        case let (x, y) where x < 300 && y == false: weatherIcon(index, "11d")
        
        //Drizzle
        case let (x, y) where x < 500 && y == true:  weatherIcon(index, "09n")
        case let (x, y) where x < 500 && y == false: weatherIcon(index, "09d")

        //Rain
        case let (x, y) where x <= 504 && y == true:  weatherIcon(index, "10n")
        case let (x, y) where x <= 504 && y == false: weatherIcon(index, "10d")
            
        case let (x, y) where x == 511 && y == true:  weatherIcon(index, "13n")
        case let (x, y) where x == 511 && y == false: weatherIcon(index, "13d")
            
        case let (x, y) where x < 600 && y == true:  weatherIcon(index, "09n")
        case let (x, y) where x < 600 && y == false: weatherIcon(index, "09d")
            
        //Snow
        case let (x, y) where x < 700 && y == true:  weatherIcon(index, "13n")
        case let (x, y) where x < 700 && y == false: weatherIcon(index, "13d")
            
        //Atmosphere
        case let (x, y) where x < 800 && y == true:  weatherIcon(index, "50n")
        case let (x, y) where x < 800 && y == false: weatherIcon(index, "50d")
            
        //Clouds
        case let (x, y) where x == 800 && y == true:  weatherIcon(index, "01n")
        case let (x, y) where x == 800 && y == false: weatherIcon(index, "01d")
            
        case let (x, y) where x == 801 && y == true:  weatherIcon(index, "02n")
        case let (x, y) where x == 801 && y == false: weatherIcon(index, "02d")
            
        case let (x, y) where x > 802 || x < 804 && y == true:  weatherIcon(index, "03n")
        case let (x, y) where x > 802 || x < 804 && y == false: weatherIcon(index, "03d")
            
        case let (x, y) where x == 804 && y == true:  weatherIcon(index, "04n")
        case let (x, y) where x == 804 && y == false: weatherIcon(index, "04d")
            
        //Additional
        case let (x, y) where x < 1000 && y == true:  weatherIcon(index, "11n")
        case let (x, y) where x < 1000 && y == false: weatherIcon(index, "11d")
            
        default: weatherIcon(index, "none")
        }
    }
    
    func convertTemperature(country: String, temperature: Float) -> Float {
        if (country == "US") {
            //Convert to F
            return round(((temperature - 273.15) * 1.8) + 32)
        } else {
            //Convert to C
            return round(temperature - 273.15)
        }
    }
    
    func isTimeNight(icon: String) -> Bool {
        return icon.range(of: "n") != nil
    }
    
    /*func isTimeNight(weatherJson: JSON) -> Bool {
        var nightTime = false
        let nowTime = Date.timeIntervalBetween1970AndReferenceDate
        let sunrise = weatherJson["sys"]["sunrise"].doubleValue
        let sunset = weatherJson["sys"]["sunset"].doubleValue
        
        if nowTime < sunrise || nowTime > sunset {
            nightTime = true
        }
        
        return nightTime
    }*/
}
