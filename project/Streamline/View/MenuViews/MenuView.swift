//
//  MenuView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/27/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
import Alamofire

protocol MenuViewDelegate {
    func logoutButtonPressed()
    func settingButtonPressed()
    func groupButtonPressed()
}

class MenuView:UIView {
    var delegate: MenuViewDelegate? = nil
    var view: UIView!
    
    var profileImageView: UIImageView!
    var settingButton   : UIButton!
    var groupButton     : UIButton!
    var logoutButton    : UIButton!
    
    
    init(frame: CGRect, large: Bool) {
        print(DB.currentUser.imageUrl)
        
        super.init(frame: frame)
        
        layer.cornerRadius  = 5
        clipsToBounds       = true
        view = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        view.layer.cornerRadius = 4
        view.backgroundColor    = .white
        
        addSubview(view)
        setupProfilePicture()
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Setup functions
    func setupProfilePicture() {
        profileImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.35, y: view.frame.width * 0.05, width: view.frame.width * 0.3, height: view.frame.width * 0.3))
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = Constants.darkPurple.cgColor
        profileImageView.clipsToBounds = true
        profileImageView.image = #imageLiteral(resourceName: "albumPlaceholder")
        let url = URL(string: DB.currentUser.imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data!)
            }
        }
        
        view.addSubview(profileImageView)
    }
    
    func setupButtons(){
        settingButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.4, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        settingButton.layer.cornerRadius = 15
        settingButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        settingButton.layer.borderWidth  = 2
        
        settingButton.backgroundColor = UIColor.white
        settingButton.setTitleColor(Constants.darkPurple, for: .normal)
        settingButton.setTitle("USER SETTINGS", for: .normal)
        settingButton.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
        
        view.addSubview(settingButton)
        
        groupButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.6, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        groupButton.layer.cornerRadius = 15
        groupButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        groupButton.layer.borderWidth  = 2
        
        groupButton.backgroundColor = UIColor.white
        groupButton.setTitleColor(Constants.darkPurple, for: .normal)
        groupButton.setTitle("GROUP SETTINGS", for: .normal)
        groupButton.addTarget(self, action: #selector(groupButtonPressed), for: .touchUpInside)
        
        view.addSubview(groupButton)
        
        logoutButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.8, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        logoutButton.layer.cornerRadius = 15
        logoutButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        logoutButton.layer.borderWidth  = 2
        
        logoutButton.backgroundColor = UIColor.white
        logoutButton.setTitleColor(Constants.darkPurple, for: .normal)
        logoutButton.setTitle("LOGOUT", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        
        view.addSubview(logoutButton)
    }
    
    @objc
    func logoutButtonPressed() {
        delegate?.logoutButtonPressed()
    }
    
    @objc
    func groupButtonPressed() {
        delegate?.groupButtonPressed()
    }
    
    @objc
    func settingButtonPressed() {
        delegate?.settingButtonPressed()
    }
}
