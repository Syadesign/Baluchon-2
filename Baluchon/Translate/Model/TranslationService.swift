//
//  GetTranslation.swift
//  Baluchon
//
//  Created by Samahir Adi on 02/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class TranslationService {
    
    // MARK: - Variables
    static let shared = TranslationService(session: URLSession(configuration: .default))
    
    private let translationUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    
    private var session: URLSession
    
    // MARK: - Init
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Methods
    // Get the text translation
    func getTranslation(text: String, from: String, to: String, callback: @ escaping (Bool, _ translatedText: String?) -> Void) {

        let request = createTranslationRequest(textToTranslate: text, from: from, to: to)
        
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
                let translation = try JSONDecoder().decode(Translation.self, from: data)
                callback(true, translation.data.translations.first?.translatedText)
            } catch {
                callback(false, nil)
            }
        }
        task.resume()
    }
    
    // Create an UrlRequest to get english translation from french language
    private func createTranslationRequest(textToTranslate: String, from: String, to: String) -> URLRequest {
        var component = URLComponents(url: translationUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [
            URLQueryItem (name: "key", value: "AIzaSyDM04XaaZrYiz-vGhxTHjGMo1HBgo2rNO0"),
            URLQueryItem (name: "q", value: textToTranslate),
            URLQueryItem (name: "source", value: from),
            URLQueryItem (name: "target", value: to),
            URLQueryItem (name: "format", value: "text")
        ]
        // if component is nil, url = translationUrl
        let url = component?.url ?? translationUrl
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
