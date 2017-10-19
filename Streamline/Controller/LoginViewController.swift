//
//  LoginViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/18/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var logoImage: UIImageView!
    var connectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupLogo()
        setupButton()
    }
    
    // Setup Functions
    func setupBackground() {
        view.backgroundColor = UIColor(hex: "673ab7")
    }
    
    func setupLogo() {
        logoImage = UIImageView(frame: rRect(rx: 0, ry: 216, rw: 375, rh: 79))
        logoImage.contentMode = .scaleAspectFit
        logoImage.image = UIImage(named: "Logo")
        view.addSubview(logoImage)
    }
    
    func setupButton() {
        connectButton = UIButton(frame: rRect(rx: 75, ry: 324, rw: 239, rh: 45))
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        connectButton.setTitle("CONNECT WITH SPOTIFY", for: .normal)
        connectButton.layer.cornerRadius = 15
        view.addSubview(connectButton)
    }
    
    // Selectors
    func connectButtonPressed() {
        // This is where we will try connecting with Spotify
        
        self.performSegue(withIdentifier: "toFeed", sender: self)
        // TODO: Send the current user -> feed
    }
}
