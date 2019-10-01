//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by Samahir Adi on 27/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: Data
    static var translationCorrectData: Data {
        let bundle = (Bundle(for: FakeResponseData.self))
        let url = bundle.url(forResource: "Translation", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var currencyCorrectData: Data {
        let bundle = (Bundle(for: FakeResponseData.self))
        let url = bundle.url(forResource: "Currency", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var weatherCorrectData: Data {
        let bundle = (Bundle(for: FakeResponseData.self))
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let translationIncorrectData = "erreur".data(using: .utf8)!
    static let currencyIncorrectData = "erreur".data(using: .utf8)!
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // MARK: Error
    class TranslationError: Error {}
    static let translationError = TranslationError()
    
    class CurrencyError: Error {}
    static let currencyError = CurrencyError()
    
    class WeatherError: Error {}
    static let weatherError = WeatherError()

}
