//
//  SecondViewController.swift
//  Baluchon
//
//  Created by Samahir Adi on 16/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var placeHolderToTranslate: UILabel!
    @IBOutlet weak var placeHolderTranslated: UILabel!
    @IBOutlet weak var whiteViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var translateButtonView: UIView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var textTranslated: UITextView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var clearButton: UIImageView!
    @IBOutlet weak var whiteViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoundedView()
        setupTextView()
        setupWhiteView()
        textToTranslate.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Add gesture to the translate button
        let translateGesture = UITapGestureRecognizer(target: self, action: #selector(translate))
        self.translateButtonView.addGestureRecognizer(translateGesture)
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
    
    // MARK: - Variables
    let french = "fr"
    let english = "en"
    
    enum State: String {
        case fromFrench
        case fromEnglish
    }
    
    var currentState: State = .fromFrench {
        didSet {
            switch currentState {
            case .fromFrench:
                placeHolderToTranslate.text = "French"
                placeHolderTranslated.text = "English"
            case .fromEnglish:
                placeHolderToTranslate.text = "English"
                placeHolderTranslated.text = "French"
            }
        }
    }
    
    // MARK: - Manage Keyboard
    @objc private func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: duration) {
                self.whiteViewTopConstraint.constant = 0
                self.whiteViewBottomConstraint.constant = keyboardHeight - 80
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
    
    // MARK: - Actions
    
    @IBAction func dismissKeybooard(_ sender: Any) {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction func switchLanguage(_ sender: Any) {
        if self.currentState == .fromFrench {
            self.currentState = .fromEnglish
        } else if self.currentState == .fromEnglish {
           self.currentState = .fromFrench
        }
    }
    
    // MARK: - Methods
    func translateFromLanguage(from: String, to: String) {
        self.currentState = .fromFrench
        guard let text = textToTranslate.text else {return}
        if text.isEmpty {
            displayAlert("Please enter a valid text")
        }
        TranslationService.shared.getTranslation(text: text, from: from, to: to, callback: ({ (success, translatedText) in
            DispatchQueue.main.async {
                if success, let translatedText = translatedText {
                    self.textTranslated.text = translatedText
                } else {
                    self.displayAlert("Please retry after few minutes")
                }
            }
        }))
    }
    
    @objc func translate() {
        if currentState == .fromFrench {
            translateFromLanguage(from: french, to: english)
        } else if currentState == .fromEnglish {
           translateFromLanguage(from: english, to: french)
        }
    }
    
    @objc func clearText() {
        textToTranslate.text = ""
        textTranslated.text = ""
        placeHolderTranslated.isHidden = false
        placeHolderToTranslate.isHidden = false
    }
    
    // Put rounded corners to the textViews
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
    
    // WhiteView rounded corners
    func setupWhiteView() {
        let width = self.whiteView.frame.width
        self.whiteView.layer.cornerRadius = width/15
        self.greyView.layer.cornerRadius = width/15
    }
    
    // Make the button view circle
    func setupRoundedView() {
        let width = self.translateButtonView.bounds.width
        self.translateButtonView.layer.cornerRadius = width / 2
        self.translateButtonView.clipsToBounds = true
    }
    
}

// MARK: - TextView Delegate
extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.contentInset = .zero
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textToTranslate.text.isEmpty == true {
            textTranslated.text = ""
            clearButton.isHidden = true
            placeHolderTranslated.isHidden = false
            placeHolderToTranslate.isHidden = false
        } else {
            clearButton.isHidden = false
            placeHolderTranslated.isHidden = true
            placeHolderToTranslate.isHidden = true
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty == true {
            placeHolderTranslated.isHidden = false
            placeHolderToTranslate.isHidden = false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            placeHolderTranslated.isHidden = false
            placeHolderToTranslate.isHidden = false
            clearButton.isHidden = true
        }
    }
}
