//
//  ViewController.swift
//  Weather
//
//  Created by mac on 20.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OpenWeatherMapDelegate {
    @IBOutlet weak var iconImageView: UIImageView!
    
    var openWeather = OpenWeatherMap()
    
    @IBAction func cityButtonTapped(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.openWeather.delegate = self
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
                self.openWeather.getWeatherFor(textField.text!)
            }
        }
        alert.addAction(ok)
        
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: OpenWeatherMapDelegate
    func updateWeatherInfo() {
        print(openWeather.nameCity as Any)
        print(openWeather.temperature as Any)
    }
}
