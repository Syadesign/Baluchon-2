//
//  SecondViewController.swift
//  Baluchon
//
//  Created by Samahir Adi on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoundedView()
        setupTextView()
        setupWhiteView()
        
        textToTranslate.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Add gesture to the translate button
        let translateGesture = UITapGestureRecognizer(target: self, action: #selector(translate))
        self.roundedView.addGestureRecognizer(translateGesture)
        translateGesture.delegate = self
        translateGesture.isEnabled = true
        
        // Add gesture to the clear button
        let clearGesture = UITapGestureRecognizer(target: self, action: #selector(clearText))
        self.clearButton.addGestureRecognizer(clearGesture)
        clearGesture.delegate = self
        clearGesture.isEnabled = true
        clearButton.isHidden = true
        // TextViewDelegate
        self.textToTranslate.delegate = self
        self.textTranslated.delegate = self
        
        // Manage Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBOutlet weak var placeHolderEnglish: UILabel!
    @IBOutlet weak var placeHolderFrench: UILabel!
    @IBOutlet weak var greyViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var textToTranslate: UITextView!
    
    @IBOutlet weak var textTranslated: UITextView!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var greyView: UIView!
    
    @IBOutlet weak var clearButton: UIImageView!
    
    func setupRoundedView() {
        let width = self.roundedView.bounds.width
        self.roundedView.layer.cornerRadius = width / 2
        self.roundedView.clipsToBounds = true
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
    
    @IBAction func dismissKeybooard(_ sender: Any) {
        textToTranslate.resignFirstResponder()
    }
    
    // MARK: Methods
    
    @objc func translate() {
        guard let text = textToTranslate.text else {return}
        if text.isEmpty {
            displayAlert("Vous devez entrer un texte valide.")
        }
        GetTranslation.getEnglishTranslation(text: text, callback: ({ (success, translatedText) in
            DispatchQueue.main.async {
            if success, let translatedText = translatedText {
                print ("\(text)")
                    var text: String {
                        get {
                        var textToTrans = GetTranslation.text
                        textToTrans = self.textToTranslate.text
                        return textToTrans
                        }
                    }
                    self.textTranslated.text = translatedText
                    print ("translation :\(translatedText)")
                
            } else {
                self.displayAlert("Le serveur n'a pas pu récuperer la traduction, veuillez retenter d'ici quelques minutes")
                }
            }
        }))
    }
    
    @objc func clearText() {
        textToTranslate.text = ""
        textTranslated.text = ""
        placeHolderFrench.isHidden = false
        placeHolderEnglish.isHidden = false
    }
    
    func setupTextView() {
        let textViewArray = [textTranslated, textToTranslate]
        let width = self.textToTranslate.bounds.width
        for txtView in textViewArray {
            txtView!.layer.cornerRadius = width / 20
            txtView!.clipsToBounds = false
            txtView!.layer.shadowOpacity = 0.4
            txtView!.layer.shadowRadius = 13
            txtView!.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }
    
    func setupWhiteView() {
        let width = self.whiteView.frame.width
        self.whiteView.layer.cornerRadius = width/15
        self.greyView.layer.cornerRadius = width/15
    }
    
    func getText() -> String {
        return textToTranslate.text
    }
    
}

extension TranslateViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print ("text did begin editing")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textToTranslate.text.isEmpty == true {
            textTranslated.text = ""
            clearButton.isHidden = true
            placeHolderFrench.isHidden = false
            placeHolderEnglish.isHidden = false
            print ("text is Empty")
        } else {
             clearButton.isHidden = false
            placeHolderFrench.isHidden = true
            placeHolderEnglish.isHidden = true
            print ("text did change")
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print ("text should end editing")
        if textView.text.isEmpty == true {
        placeHolderFrench.isHidden = false
        placeHolderEnglish.isHidden = false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            placeHolderFrench.isHidden = false
            placeHolderEnglish.isHidden = false
            clearButton.isHidden = true
        }
        print ("text did end editing")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print ("text should begin editing")
        return true
    }

}
