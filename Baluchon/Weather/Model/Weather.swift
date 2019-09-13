//
//  GetWeather.swift
//  Baluchon
//
//  Created by Michael Martinez on 06/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let weather: [WeatherElement]
    let main: Main
}

struct Main: Codable {
    let temp: Double
}

struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String?
}
