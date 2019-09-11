//
//  FirstViewController.swift
//  Baluchon
//
//  Created by Michael Martinez on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var currencyToConvertTextField: UITextField!
    @IBOutlet weak var currencyConvertedTextField: UITextField!
    @IBOutlet weak var dollarView: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var greyView: UIView!
    
    @IBOutlet weak var greyViewTopConstraint: NSLayoutConstraint!
    // MARK: ViewCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoundedView()
        setupTextField()
        setupWhiteView()
        currencyConvertedTextField.delegate = self
        currencyToConvertTextField.delegate = self
    
        // Add gesture to the dollar button
        let convertDollars = UITapGestureRecognizer(target: self, action: #selector(convert))
        convertDollars.delegate = self
        self.dollarView.addGestureRecognizer(convertDollars)
        convertDollars.isEnabled = true
        
        // Manage Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        currencyToConvertTextField.resignFirstResponder()
    }

    // MARK: Manage Keyboard
    @objc private func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        UIView.animate(withDuration: duration) {
            self.greyViewTopConstraint.constant = 0
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
         guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
            UIView.animate(withDuration: duration) {
                self.greyViewTopConstraint.constant = 200
        }
    }

    // MARK: Methods

    @objc func convert() {
        self.dollarView.backgroundColor = .blue
        guard let toConvert = self.currencyToConvertTextField.text else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        GetCurrency.getDailyCurrency(callback: ({ (success, currency) in
            DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if success, let currency = currency {
                                    print ("currency :\(currency)")
                    guard let rate = currency.rates["USD"] else {return}
                    let result = (Double(toConvert.removeWhitespace()))! * (rate)
                    let resultWith2Decimals = String(format: "%.2f", ceil(result*100)/100)
                    self.currencyToConvertTextField.text = toConvert.removeWhitespace() + " €"
                    self.currencyConvertedTextField.text = resultWith2Decimals + " $"
               
            } else {
                self.displayAlert("Nous n'avons pas pu obtenir le taux de change. Veuillez réitérer votre demande dans quelques minutes.")
                print ("alert error currency")
            }
            }
        }))
    }
    
    func setupRoundedView() {
        let width = self.dollarView.bounds.width
        self.dollarView.layer.cornerRadius = width / 2
        self.dollarView.clipsToBounds = true
    }
    
    func setupTextField() {
        let textFieldArray = [currencyToConvertTextField, currencyConvertedTextField]
        let width = self.currencyToConvertTextField.bounds.width
        for textField in textFieldArray {
            textField!.layer.cornerRadius = width / 20
            textField?.layer.shadowRadius = 13
            textField?.layer.shadowOffset = CGSize(width: 1.3, height: 0.8)
            textField?.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textField?.layer.shadowOpacity = 0.4
        }
    }
    
    func setupWhiteView() {
        let width = self.whiteView.frame.width
        self.whiteView.layer.cornerRadius = width/15
        self.greyView.layer.cornerRadius = width/15
    }

}

extension CurrencyViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print ("croix apuyée")
        currencyConvertedTextField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        guard !str.isEmpty else { return true }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter.number(from: str)?.intValue != nil
    }
    
}

extension String {
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
}
