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
            rRect(rx: 75, ry: 315, rw: 239, rh: 45))
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        connectButton.layer.cornerRadius = 15
        connectButton.backgroundColor = UIColor.white
        view.addSubview(connectButton)
        // Drop Shadow
        connectButton.layer.shadowRadius = 3
        connectButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        connectButton.layer.shadowColor = UIColor.black.cgColor
        connectButton.layer.shadowOpacity = 0.35
        
        let connectLabel = UILabel(frame:
            rRect(rx: 120, ry: 328, rw: 185, rh: 20))
        connectLabel.textColor = Constants.darkPurple
        connectLabel.text = "CONNECT WITH SPOTIFY"
        connectLabel.textAlignment = .center
        connectLabel.font = Constants.averageSans
        connectLabel.font = UIFont.systemFont(ofSize: 14, weight: 1)
        view.addSubview(connectLabel)
        
        let spotifyLogo = UIImageView(frame:
            rRect(rx: 90, ry: 325, rw: 26, rh: 26))
        spotifyLogo.image = #imageLiteral(resourceName: "spotify-logo")
        view.addSubview(spotifyLogo)
    }

    

}
