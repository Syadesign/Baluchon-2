//
//  GetWeather.swift
//  Baluchon
//
//  Created by Michael Martinez on 06/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class GetWeather {
    
    private static let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    
    static func getDailyWeather(city: String, callback: @ escaping (Bool, Weather?) -> Void) {
        guard let request = createWeatherRequest(city: city) else {
            print ("request = nil")
            callback(false, nil)
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print ("request error \(error!.localizedDescription)")
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print ("http code response error")
                callback(false, nil)
                return
            }
            print ("\(response)")
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                callback(true, weather)
            } catch {
                print ("error while parsing response \(error)")
                callback(false, nil)
            }
        }
        task.resume()
    }
    
    private static func createWeatherRequest(city: String) -> URLRequest? {
        var component = URLComponents(url: weatherUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [
            URLQueryItem (name: "appid", value: "6bf8e9a72c8f83b5ce3396195b1df5da"),
            URLQueryItem (name: "id", value: city),
            URLQueryItem (name: "lang", value: "fr"),
            URLQueryItem (name: "units", value: "metric")
        ]
        guard let urlComponent = component, let url = urlComponent.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
