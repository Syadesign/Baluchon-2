//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Samahir Adi on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var newYorkIconImage: UIImageView!
    @IBOutlet weak var parisIconImage: UIImageView!
    @IBOutlet var rectView: [UIView]!
    @IBOutlet weak var parisDegreesLabel: UILabel!
    
    @IBOutlet weak var newYorkDegreesLabel: UILabel!
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRectView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeatherFrom()
    }
    
    // MARK: - Variables
    private let parisID = "6455259"
    private let newYorkID = "5128638"
    
    // MARK: - Methods
    // Get and display the current temp and the weather description icon
    func getWeatherFrom() {
        // Paris
        WeatherService.shared.getWeather(city: parisID) { (success, weather) in
            DispatchQueue.main.async {
                if success, let weather = weather {
                    let temp = (round(weather.main.temp)).removeZerosFromEnd()
                    self.parisDegreesLabel.text = temp + "°"
                    self.parisIconImage.image = self.getImage(for: weather.weather[0])
                } else {
                    self.displayAlert("We could'nt get the current weather, please retry after few minutes.")
                }
            }
        }
        
        // New-York
        WeatherService.shared.getWeather(city: newYorkID) { (success, weather) in
            DispatchQueue.main.async {
                if success, let weather = weather {
                    let temp = (round(weather.main.temp)).removeZerosFromEnd()
                    self.newYorkDegreesLabel.text = temp + "°"
                    self.newYorkIconImage.image = self.getImage(for: weather.weather[0])
                } else {
                    self.displayAlert("We could'nt get the current weather, please retry after few minutes.")
                }
            }
        }
    }
    
    // Put rounded corner to the grey view
    private func setupRectView() {
        for rect in rectView {
            let width = rect.bounds.width
            rect.layer.cornerRadius = width / 20
        }
    }
    
    // Get a weather icon for each weather type
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
