//
//  Currency.swift
//  Baluchon
//
//  Created by Michael Martinez on 09/08/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let base: String
    let rates: [String: Double]
}
