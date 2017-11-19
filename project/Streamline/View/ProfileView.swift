//
//  ProfileView.swift
//  Streamline
//
//  Created by Stephen Jayakar on 11/17/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    var profileImage: UIImageView!
    var name: UILabel!
    var logoutButton: UIButton!
    var backButton: UIButton!
    var delegate: ProfileViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        // TODO: This should be a square
        profileImage = UIImageView(frame: Utils.rRect(rx: 65, ry: 60, rw: 245, rh: 245))
        profileImage.contentMode = .scaleAspectFill
        DB.currentUser.getProfileImage { (img) in
            self.profileImage.image = img
        }
        addSubview(profileImage)
        
        name = UILabel(frame: Utils.rRect(rx: 0, ry: 348, rw: 375, rh: 30))
        name.text = DB.currentUser.username
        name.font = Constants.averageSans?.withSize(30)
        name.textColor = UIColor.black
        name.adjustsFontSizeToFitWidth = true
        addSubview(name)
        
        logoutButton = UIButton(frame: Utils.rRect(rx: 56, ry: 574, rw: 107, rh: 31))
        logoutButton.backgroundColor = Constants.darkPurple
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        addSubview(logoutButton)
        
        backButton = UIButton(frame: Utils.rRect(rx: 213, ry: 574, rw: 107, rh: 31))
        backButton.backgroundColor = UIColor.black
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addSubview(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    @objc
    func logoutButtonPressed() {
        delegate?.logoutButtonPressed()
    }
    
    @objc
    func backButtonPressed() {
        delegate?.backButtonPressed()
    }
}

protocol ProfileViewDelegate {
    func logoutButtonPressed()
    func backButtonPressed()
}
