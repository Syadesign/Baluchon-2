//
//  UIViewController+Alert.swift
//  Baluchon
//
//  Created by Samahir Adi on 13/08/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(_ message: String) {
        let alertMessage = message
        let alert = UIAlertController(title: "Erreur", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
