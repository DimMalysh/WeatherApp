//
//  ForecastViewController.swift
//  Weather
//
//  Created by mac on 22.03.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
    @IBOutlet weak var time4Label: UILabel!
    
    @IBOutlet weak var icon1View: UIImageView!
    @IBOutlet weak var icon2View: UIImageView!
    @IBOutlet weak var icon3View: UIImageView!
    @IBOutlet weak var icon4View: UIImageView!

    @IBOutlet weak var temperature1Label: UILabel!
    @IBOutlet weak var temperature2Label: UILabel!
    @IBOutlet weak var temperature3Label: UILabel!
    @IBOutlet weak var temperature4Label: UILabel!
    
    @IBOutlet weak var subview: UIView!
    
    var time1Text: String!
    var time2Text: String!
    var time3Text: String!
    var time4Text: String!
    
    var icon1Image: UIImage!
    var icon2Image: UIImage!
    var icon3Image: UIImage!
    var icon4Image: UIImage!
    
    var temperature1Text: String!
    var temperature2Text: String!
    var temperature3Text: String!
    var temperature4Text: String!
    
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
        
        time1Label.text = time1Text
        time2Label.text = time2Text
        time3Label.text = time3Text
        time4Label.text = time4Text
        
        icon1View.image = icon1Image
        icon2View.image = icon2Image
        icon3View.image = icon3Image
        icon4View.image = icon4Image
        
        temperature1Label.text = temperature1Text
        temperature2Label.text = temperature2Text
        temperature3Label.text = temperature3Text
        temperature4Label.text = temperature4Text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
