//
//  SettingView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/27/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
protocol SettingViewDelegate {
    func setNameButtonPressed()
}

class SettingView:UIView {
    var delegate: SettingViewDelegate? = nil
    var view: UIView!
    
    var profileImageView    : UIImageView!
    var usernameTextField   : UITextField!
    var setNameButton       : UIButton!
    
    
    init(frame: CGRect, large: Bool) {
        print(DB.currentUser.imageUrl)
        
        super.init(frame: frame)
        
        layer.cornerRadius  = 5
        clipsToBounds       = true
        view = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        view.layer.cornerRadius = 4
        view.backgroundColor    = .white
        
        addSubview(view)
        
        setupTextField()
        setupProfilePicture()
        setupButton()
    }
    
    //Setup Functions
    func setupProfilePicture() {
        profileImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.35, y: view.frame.width * 0.05, width: view.frame.width * 0.3, height: view.frame.width * 0.3))
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderWidth  = 3.0
        profileImageView.layer.borderColor  = Constants.darkPurple.cgColor
        profileImageView.clipsToBounds      = true
        profileImageView.image              = #imageLiteral(resourceName: "albumPlaceholder")
        let url = URL(string: DB.currentUser.imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data!)
            }
        }
        
        view.addSubview(profileImageView)
    }
    
    func setupTextField(){
        usernameTextField                    = UITextField(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.47, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        usernameTextField.layer.cornerRadius = 15
        usernameTextField.backgroundColor    = UIColor.white
        usernameTextField.textColor          = Constants.darkPurple
        usernameTextField.placeholder        = "  Change Username: " + DB.currentUser.username
        view.addSubview(usernameTextField)
    }
    
    func setupButton() {
        setNameButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.70, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        setNameButton.layer.cornerRadius = 15
        setNameButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        setNameButton.layer.borderWidth  = 2
        
        setNameButton.backgroundColor = UIColor.white
        setNameButton.setTitleColor(Constants.darkPurple, for: .normal)
        setNameButton.setTitle("SET USERNAME", for: .normal)
        setNameButton.addTarget(self, action: #selector(setNameButtonPressed), for: .touchUpInside)
        
        view.addSubview(setNameButton)
    }
    
    @objc
    func setNameButtonPressed() {
        delegate?.setNameButtonPressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
