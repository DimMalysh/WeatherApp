//
//  ViewController.swift
//  Weather
//
//  Created by mac on 20.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    let url = "http://api.openweathermap.org/data/2.5/weather?q=London&appid=4e63f48bb2d090d7fb7d80f6447ace6a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let stringURL = URL(string: url)
        let session = URLSession.shared
        let task = session.downloadTask(with: stringURL!) { (location: URL?, responce: URLResponse?, error: Error?) in
            let weatherData = try? Data(contentsOf: stringURL!)
            let weatherJson = try? JSONSerialization.jsonObject(with: weatherData!, options: []) as! Dictionary<String, Any>
            let weather = OpenWeatherMap(weatherJson: weatherJson!)
            
            if error == nil {
                print(weather.nameCity)
                print(weather.temperature)
                print(weather.description)
                print(weather.currentTime!)
                print(weather.icon!)
                
                DispatchQueue.main.async {
                    self.iconImageView.image = weather.icon!
                }
            } else {
                print("Error: \(error!)")
            }
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
