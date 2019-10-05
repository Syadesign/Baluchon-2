//
//  GetWeather.swift
//  Baluchon
//
//  Created by Samahir Adi on 06/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class WeatherService {
    
    // MARK: - Variables
    static let shared = WeatherService(session: URLSession(configuration: .default))
    
    private let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    
    private var session: URLSession
    
    // MARK: - Init
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Methods
    // Get the current weather
    func getWeather(city: String, callback: @ escaping (Bool, Weather?) -> Void) {
       
        let request = createWeatherRequest(city: city)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check the data
            guard let data = data, error == nil else {
                callback(false, nil)
                return
            }
            // Check the response code
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(false, nil)
                return
            }
            
            // Parse json
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                callback(true, weather)
            } catch {
                callback(false, nil)
            }
        }
        task.resume()
    }
    // Create a request to get the current weather in a city
    private func createWeatherRequest(city: String) -> URLRequest {
        var component = URLComponents(url: weatherUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [
            URLQueryItem (name: "appid", value: "6bf8e9a72c8f83b5ce3396195b1df5da"),
            URLQueryItem (name: "id", value: city),
            URLQueryItem (name: "lang", value: "fr"),
            URLQueryItem (name: "units", value: "metric")
        ]
        // if component is nil, url = weatherUrl
        let url = component?.url ?? weatherUrl
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
