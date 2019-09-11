//
//  BaluchonTabBar.swift
//  Baluchon
//
//  Created by Michael Martinez on 17/07/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class BaluchonTabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
//        setupImage()
//        setupBlackLine()
//        setupRoundedView()
//        setupIconView()
    }
    
//var imageCity = UIImageView()
//var blackLine = UIView()
//var iconView = UIImageView()
//var roundedView = UIView()
//
//    func setupImage() {
//        self.delegate = self
//        self.imageCity.image = #imageLiteral(resourceName: "brooklynBridge")
//        self.imageCity.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(imageCity)
//        self.imageCity.contentMode = .scaleAspectFill
//        let width: CGFloat = view.frame.width
//        let height: CGFloat = view.frame.height/2
//        self.imageCity.widthAnchor.constraint(equalToConstant: width).isActive = true
//        self.imageCity.heightAnchor.constraint(equalToConstant: height).isActive = true
//        self.imageCity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        self.imageCity.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
//    }
//
//    func setupBlackLine() {
//        self.blackLine.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(blackLine)
//        self.blackLine.backgroundColor = .black
//        let width: CGFloat = view.frame.width
//        let height: CGFloat = 20
//        self.blackLine.widthAnchor.constraint(equalToConstant: width).isActive = true
//        self.blackLine.heightAnchor.constraint(equalToConstant: height).isActive = true
//        self.blackLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        self.blackLine.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//    }
//
//    func setupIconView() {
//        let width: CGFloat = 80
//        self.iconView.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: width, height: width)
//        self.iconView.backgroundColor = .black
//        self.iconView.layer.cornerRadius = width / 2
//        self.iconView.clipsToBounds = false
//        self.view.addSubview(self.iconView)
//
//        self.iconView.translatesAutoresizingMaskIntoConstraints = false
//        self.iconView.widthAnchor.constraint(equalToConstant: width).isActive = true
//        self.iconView.heightAnchor.constraint(equalToConstant: width).isActive = true
//        self.iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        self.iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        self.iconView.contentMode =  .scaleAspectFit
//        self.iconView.image = #imageLiteral(resourceName: "whiteCurrency")
//    }
//
//    func setupRoundedView() {
//        let width: CGFloat = 120
//        self.roundedView.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: width, height: width)
//        self.roundedView.backgroundColor = .black
//        self.roundedView.layer.cornerRadius = width / 2
//        self.roundedView.clipsToBounds = true
//        self.view.addSubview(self.roundedView)
//
//        self.roundedView.translatesAutoresizingMaskIntoConstraints = false
//        self.roundedView.widthAnchor.constraint(equalToConstant: width).isActive = true
//        self.roundedView.heightAnchor.constraint(equalToConstant: width).isActive = true
//        self.roundedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        self.roundedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//    }

}

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 90 // adjust your size here
//        return sizeThatFits
//    }
//}
