//
//  String+format.swift
//  Baluchon
//
//  Created by Samahir Adi on 24/09/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import Foundation

extension String {
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
}
