//
//  LoginView.swift
//  Streamline
//
//  Created by Annie Tang on 10/21/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

extension LoginViewController {
    
    func setupUI() {
        setupLandingImage()
        setupButton()
    }
    
    func setupLandingImage() {
        let landingImageView = UIImageView(frame: view.bounds)
        landingImageView.image = #imageLiteral(resourceName: "LandingImage")
        view.addSubview(landingImageView)
    }
    
    func setupButton() {
        connectButton = UIButton(frame:
            rRect(rx: 75, ry: 324, rw: 239, rh: 45))
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        connectButton.layer.cornerRadius = 15
        connectButton.backgroundColor = UIColor.white
        view.addSubview(connectButton)
        
        let connectLabel = UILabel(frame:
            rRect(rx: 120, ry: 328, rw: 185, rh: 20))
        connectLabel.textColor = Constants.darkPurple
        connectLabel.text = "CONNECT WITH SPOTIFY"
        connectLabel.font = Constants.averageSans
        connectLabel.font = connectLabel.font.withSize(15)
        view.addSubview(connectLabel)
    }

    

}
