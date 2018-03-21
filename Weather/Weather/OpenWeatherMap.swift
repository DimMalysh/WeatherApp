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
    
    func updateWeatherIcon(condition: Int, nightTime: Bool, index: Int) -> UIImage {
        var imageName: String
        
        switch (condition, nightTime) {
        //Thunderstorm
        case let (x, y) where x < 300 && y == true:  imageName = "11n"
        case let (x, y) where x < 300 && y == false: imageName = "11d"
        
        //Drizzle
        case let (x, y) where x < 500 && y == true:  imageName = "09n"
        case let (x, y) where x < 500 && y == false: imageName = "09d"

        //Rain
        case let (x, y) where x <= 504 && y == true:  imageName = "10n"
        case let (x, y) where x <= 504 && y == false: imageName = "10d"
            
        case let (x, y) where x == 511 && y == true:  imageName = "13n"
        case let (x, y) where x == 511 && y == false: imageName = "13d"
            
        case let (x, y) where x < 600 && y == true:  imageName = "09n"
        case let (x, y) where x < 600 && y == false: imageName = "09d"
            
        //Snow
        case let (x, y) where x < 700 && y == true:  imageName = "13n"
        case let (x, y) where x < 700 && y == false: imageName = "13d"
            
        //Atmosphere
        case let (x, y) where x < 800 && y == true:  imageName = "50n"
        case let (x, y) where x < 800 && y == false: imageName = "50d"
            
        //Clouds
        case let (x, y) where x == 800 && y == true:  imageName = "01n"
        case let (x, y) where x == 800 && y == false: imageName = "01d"
            
        case let (x, y) where x == 801 && y == true:  imageName = "02n"
        case let (x, y) where x == 801 && y == false: imageName = "02d"
            
        case let (x, y) where x > 802 || x < 804 && y == true:  imageName = "03n"
        case let (x, y) where x > 802 || x < 804 && y == false: imageName = "03d"
            
        case let (x, y) where x == 804 && y == true:  imageName = "04n"
        case let (x, y) where x == 804 && y == false: imageName = "04d"
            
        //Additional
        case let (x, y) where x < 1000 && y == true:  imageName = "11n"
        case let (x, y) where x < 1000 && y == false: imageName = "11d"
            
        default: imageName = "none"
        }
        
        let iconImage = UIImage(named: imageName)
        return iconImage!
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
