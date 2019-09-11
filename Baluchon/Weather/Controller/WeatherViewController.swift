//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Michael Martinez on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: View cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRectView()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeather()
    }

    // MARK: Variables

    enum WeatherState {
        case sunny
        case cloudy
        case sunnyCloudy
        case rainy
        case foggy
        case stormy
    }
    
    let parisID = "6455259"
    let newYorkID = "5128638"

    // MARK: Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var newYorkIconImage: UIImageView!
    @IBOutlet weak var parisIconLabel: UIImageView!
    @IBOutlet var rectView: [UIView]!
    @IBOutlet weak var parisDegreesLabel: UILabel!
    
    @IBOutlet weak var newYorkDegreesLabel: UILabel!
    
    // MARK: Actions

    // MARK: Methods
    func getWeather() {
        GetWeather.getDailyWeather(city: parisID) { (success, weather) in
            DispatchQueue.main.async {
                if success, let weather = weather {
                    let temp = (round(weather.main.temp)).removeZerosFromEnd()
                     self.parisDegreesLabel.text = temp + "°"
                    print ("------------->\(weather)")
                } else {
                    self.displayAlert("Le serveur n'a pas pu récuperer la météo, veuillez retenter d'ici quelques minutes")
                }
            }
        }
        
        GetWeather.getDailyWeather(city: newYorkID) { (success, weather) in
            DispatchQueue.main.async {
                if success, let weather = weather {
                    let temp = (round(weather.main.temp)).removeZerosFromEnd()
                    self.newYorkDegreesLabel.text = temp + "°"
                    print ("------------->\(weather)")
                } else {
                    self.displayAlert("Le serveur n'a pas pu récuperer la météo, veuillez retenter d'ici quelques minutes")
                }
            }
        }
    }
    
    
    func setupRectView() {
        for rect in rectView {
        let width = rect.bounds.width
        rect.layer.cornerRadius = width / 20
        }
    }
    
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
