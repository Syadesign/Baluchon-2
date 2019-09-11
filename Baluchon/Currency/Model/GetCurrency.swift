//
//  GetCurrency.swift
//  Baluchon
//
//  Created by Samahir Adi on 09/08/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct GetCurrency {
    
    private static let currencyUrl = URL(string: "http://data.fixer.io/api/latest?access_key=a765f89d01bae9245018f78706a1a8de")!
    
    static func getDailyCurrency(callback: @ escaping (Bool, Currency?) -> Void) {
        guard let request = createCurrencyRequest() else {
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
        
            do {
                let currency = try JSONDecoder().decode(Currency.self, from: data)
                callback(true, currency)
            } catch {
                print ("error while parsing response \(error)")
                callback(false, nil)
            }
        }
        task.resume()
    }
    
    private static func createCurrencyRequest() -> URLRequest? {
        var component = URLComponents(url: currencyUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [
            URLQueryItem (name: "access_key", value: "a765f89d01bae9245018f78706a1a8de"),
            URLQueryItem (name: "base", value: "EUR"),
            URLQueryItem (name: "symbols", value: "USD")
        ]
        guard let urlComponent = component, let url = urlComponent.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
