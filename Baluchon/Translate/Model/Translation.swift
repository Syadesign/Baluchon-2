//
//  Translation.swift
//  Baluchon
//
//  Created by Samahir Adi on 02/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

// MARK: - Translation
struct Translation: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [TranslationElement]
}

// MARK: - TranslationElement
struct TranslationElement: Codable {
    let translatedText: String
}
