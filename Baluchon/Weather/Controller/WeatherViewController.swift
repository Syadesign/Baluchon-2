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
    @IBOutlet weak var parisIconImage: UIImageView!
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
                    self.parisIconImage.image = self.getImage(for: weather.weather[0])
                    print ("-------------> Paris: \(weather)")
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
                    self.newYorkIconImage.image = self.getImage(for: weather.weather[0])
                    print ("-------------> New-York: \(weather)")
                } else {
                    self.displayAlert("Le serveur n'a pas pu récuperer la météo, veuillez retenter d'ici quelques minutes")
                }
            }
        }
    }
    
    private func setupRectView() {
        for rect in rectView {
            let width = rect.bounds.width
            rect.layer.cornerRadius = width / 20
        }
    }
    
    private func getImage(for weatherElement: WeatherElement) -> UIImage {
        
        if let main = weatherElement.main {
            
            if main.contains("Clouds") {
                return #imageLiteral(resourceName: "cloud")
            } else if main.contains("Clear") {
                return #imageLiteral(resourceName: "whiteSun")
            } else if main.contains("Rain") {
                return #imageLiteral(resourceName: "rain")
            } else if main.contains("Thunderstorm") {
                return #imageLiteral(resourceName: "storm")
            } else if main.contains("Snow") {
                return #imageLiteral(resourceName: "whiteSun")
            } else if main.contains("Drizzle") {
                return #imageLiteral(resourceName: "drizzle")
            } else if main.contains("Mist") || main.contains("Fog") {
                return #imageLiteral(resourceName: "whiteFog")
            }
        }
        return #imageLiteral(resourceName: "whiteFog")
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
