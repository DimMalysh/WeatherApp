//
//  OpenWeatherMap.swift
//  Weather
//
//  Created by mac on 20.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit

protocol OpenWeatherMapDelegate {
    func updateWeatherInfo()
}

class OpenWeatherMap {
    let weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    
    var nameCity: String?
    var temperature: Float?
    /*var description: String
    var currentTime: String?
    var icon: UIImage?*/
    
    var delegate: OpenWeatherMapDelegate!
    
    func getWeatherFor(_ city: String) {
        let parameters = ["q" : city, "appid" : "4e63f48bb2d090d7fb7d80f6447ace6a"]
        request(weatherUrl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.error != nil {
            
            } else {
                let weatherJson = JSON(response.value!)
                
                if let name = weatherJson["name"].string {
                    self.nameCity = name
                }
                
                if let temperature = weatherJson["main"]["temp"].float {
                    self.temperature = temperature
                    self.temperature! -= 273.15
                }
                
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo()
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
    
    func wetherIcon(stringIcon: String) -> UIImage {
        let imageName: String
        
        switch stringIcon {
        case "01d": imageName = "01d"
        case "02d": imageName = "02d"
        case "03d": imageName = "03d"
        case "04d": imageName = "04d"
        case "09d": imageName = "09d"
        case "10d": imageName = "10d"
        case "11d": imageName = "11d"
        case "13d": imageName = "13d"
        case "50d": imageName = "50d"
        case "01n": imageName = "01n"
        case "02n": imageName = "02n"
        case "03n": imageName = "03n"
        case "04n": imageName = "04n"
        case "09n": imageName = "09n"
        case "10n": imageName = "10n"
        case "11n": imageName = "11n"
        case "13n": imageName = "13n"
        case "50n": imageName = "50n"
        default: imageName = "none"
        }
        
        let iconImage = UIImage(named: imageName)
        return iconImage!
    }
}
