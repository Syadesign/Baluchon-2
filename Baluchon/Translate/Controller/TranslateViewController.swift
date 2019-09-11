//
//  SecondViewController.swift
//  Baluchon
//
//  Created by Michael Martinez on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoundedView()
        setupTextView()
        setupWhiteView()
        
//        textTranslated.clipsToBounds = true
//        textToTranslate.clipsToBounds = true
        textToTranslate.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Add gesture to the trannslate button
        let translateGesture = UITapGestureRecognizer(target: self, action: #selector(translate))
        translateGesture.delegate = self
        self.roundedView.addGestureRecognizer(translateGesture)
        translateGesture.isEnabled = true
        
        // Manage Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBOutlet weak var greyViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var textToTranslate: UITextView!
    
    @IBOutlet weak var textTranslated: UITextView!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var greyView: UIView!
    
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
        self.roundedView.backgroundColor = .orange
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
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textToTranslate.text.isEmpty == true {
            textTranslated.text = ""
        }
    }

}
