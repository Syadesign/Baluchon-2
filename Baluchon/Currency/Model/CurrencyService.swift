//
//  GetCurrency.swift
//  Baluchon
//
//  Created by Samahir Adi on 09/08/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

// MARK: - Welcome
class CurrencyService {
    
    static var shared = CurrencyService()
    private init() {}
    
    private let currencyUrl = URL(string: "http://data.fixer.io/api/latest?access_key=a765f89d01bae9245018f78706a1a8de")!
    
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getDailyCurrency(callback: @ escaping (Bool, Currency?) -> Void) {
        guard let request = createCurrencyRequest() else {
            print ("request = nil")
            callback(false, nil)
            return
        }
       
        task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
//                print ("request error \(error!.localizedDescription)")
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
        task?.resume()
    }
    
    private func createCurrencyRequest() -> URLRequest? {
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
