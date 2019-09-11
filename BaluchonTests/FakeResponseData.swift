//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by Michael Martinez on 06/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: Data
    var translationCorrectData: Data {
        let bundle = (Bundle(for: FakeResponseData.self))
        let url = bundle.url(forResource: "Translation", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    let translationIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // MARK: Error
    class TranslationError: Error {}
    let error = TranslationError()
}
