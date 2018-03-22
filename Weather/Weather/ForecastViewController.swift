//
//  ForecastViewController.swift
//  Weather
//
//  Created by mac on 22.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var iconViews: [UIImageView]!
    @IBOutlet var temperatureLabels: [UILabel]!
    @IBOutlet weak var subview: UIView!
    
    var timeStrings = [String(), String(), String(), String()]
    var iconImages = [UIImage(), UIImage(), UIImage(), UIImage()]
    var temperatureStrings = [String(), String(), String(), String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.subview.layer.cornerRadius = self.subview.frame.size.width / 2
        self.subview.clipsToBounds = true
        
        //Set animation view
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0.0, y: 500.0)
        subview.transform = scale.concatenating(translate)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let translate = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.subview.transform = scale.concatenating(translate)
        }, completion: nil)

        //Sort collections by tag
        timeLabels.sort { $0.tag < $1.tag }
        iconViews.sort { $0.tag < $1.tag }
        temperatureLabels.sort { $0.tag < $1.tag }
 
        var index = 0
        for timeString in timeStrings {
            timeLabels[index].text = timeString
            index += 1
        }
        
        index = 0
        for iconImage in iconImages {
            iconViews[index].image = iconImage
            index += 1
        }
        
        index = 0
        for temperatureString in temperatureStrings {
            temperatureLabels[index].text = temperatureString
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
