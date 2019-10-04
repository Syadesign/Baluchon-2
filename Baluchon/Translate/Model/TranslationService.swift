//
//  GetTranslation.swift
//  Baluchon
//
//  Created by Samahir Adi on 02/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

class TranslationService {
    
    static var shared = TranslationService(session: URLSession(configuration: .default))
    
    private let translationUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    
    private var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getTranslation(text: String, callback: @ escaping (Bool, _ translatedText: String?) -> Void) {

        let request = createTranslationRequest(textToTranslate: text)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(false, nil)
                return
            }
            
            do {
                let translation = try JSONDecoder().decode(Translation.self, from: data)
                callback(true, translation.data.translations.first?.translatedText)
            } catch {
                callback(false, nil)
            }
        }
        task.resume()
    }
    
    private func createTranslationRequest(textToTranslate: String) -> URLRequest {
        var component = URLComponents(url: translationUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [
            URLQueryItem (name: "key", value: "AIzaSyDM04XaaZrYiz-vGhxTHjGMo1HBgo2rNO0"),
            URLQueryItem (name: "q", value: textToTranslate),
            URLQueryItem (name: "source", value: "fr"),
            URLQueryItem (name: "target", value: "en"),
            URLQueryItem (name: "format", value: "text")
        ]
        // if component is nil, url = translationUrl
        let url = component?.url ?? translationUrl
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
