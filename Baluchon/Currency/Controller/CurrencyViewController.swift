//
//  FirstViewController.swift
//  Baluchon
//
//  Created by Samahir Adi on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var currencyToConvertTextField: UITextField!
    @IBOutlet weak var currencyConvertedTextField: UITextField!
    @IBOutlet weak var dollarView: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var whiteViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var whiteViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup views
        setupRoundedView()
        setupTextField()
        setupWhiteView()
        
        // Add gesture to the dollar button
        let convertDollars = UITapGestureRecognizer(target: self, action: #selector(convert))
        convertDollars.delegate = self
        self.dollarView.addGestureRecognizer(convertDollars)
        convertDollars.isEnabled = true
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        currencyToConvertTextField.resignFirstResponder()
    }
    
    // MARK: - Manage Keyboard
    @objc private func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: duration) {
                self.whiteViewTopConstraint.constant = 0
                self.whiteViewBottomConstraint.constant = keyboardHeight - 70
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        UIView.animate(withDuration: duration) {
            self.whiteViewTopConstraint.constant = 210
            self.whiteViewBottomConstraint.constant = 0
        }
    }
    
    // MARK: - Methods
    /// Method to get the daily USD currency and convert euros
    @objc func convert() {
        guard let toConvert = self.currencyToConvertTextField.text else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        CurrencyService.shared.getCurrency(callback: ({ (success, currency) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if success, let currency = currency {
                    guard let rate = currency.rates["USD"] else {return}
                    let result = (Double(toConvert.removeWhitespace()))! * (rate)
                    // Double without 2 decimals into a string
                    let resultWith2Decimals = String(format: "%.2f", ceil(result*100)/100)
                    self.currencyToConvertTextField.text = toConvert.removeWhitespace() + " €"
                    self.currencyConvertedTextField.text = resultWith2Decimals + " $"
                    
                } else {
                    self.displayAlert("We couldn't get the currency, please retry after few minutes.")
                }
            }
        }))
    }
    
    /// Make the button view circle
    func setupRoundedView() {
        let width = self.dollarView.bounds.width
        self.dollarView.layer.cornerRadius = width / 2
        self.dollarView.clipsToBounds = true
    }
    
    /// Put rounded corners to the textFields and define textField delegate
    func setupTextField() {
        // delegate
        currencyConvertedTextField.delegate = self
        currencyToConvertTextField.delegate = self
        //
        let textFieldArray = [currencyToConvertTextField, currencyConvertedTextField]
        
        // Observe when the text change
        currencyToConvertTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Configure views
        let width = self.currencyToConvertTextField.bounds.width
        for textField in textFieldArray {
            textField!.layer.cornerRadius = width / 20
            textField?.layer.shadowRadius = 13
            textField?.layer.shadowOffset = CGSize(width: 1.3, height: 0.8)
            textField?.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textField?.layer.shadowOpacity = 0.4
        }
    }
    
    /// WhiteView rounded corners
    func setupWhiteView() {
        let width = self.whiteView.frame.width
        self.whiteView.layer.cornerRadius = width/15
        self.greyView.layer.cornerRadius = width/15
    }
    
}

// MARK: - TextField Delegate
extension CurrencyViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        currencyConvertedTextField.text = ""
        return true
    }
    
    func didChange<Value>(_ changeKind: NSKeyValueChange, valuesAt indexes: IndexSet, for keyPath: __owned KeyPath<CurrencyViewController, Value>) {
        if currencyToConvertTextField.text?.isEmpty == true {
            currencyConvertedTextField.text = ""
        }
    }
    
    @objc func textFieldDidChange() {
        if currencyToConvertTextField.text?.isEmpty == true {
            currencyConvertedTextField.text = ""
        }
    }
    
}
