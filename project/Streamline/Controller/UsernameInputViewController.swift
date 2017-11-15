//
//  UsernameInputViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 11/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import UIKit

class UsernameInputViewController: UIViewController {
    var titleOne: UILabel!
    var titleTwo: UILabel!
    var titleThree: UILabel!
    var inputField: UITextField!
    var submitButton: UIButton!
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = Constants.darkPurple
        
        titleOne = UILabel(frame: Utils.rRect(rx: 0, ry: 193, rw: 375, rh: 50))
        titleOne.text = "Almost finished!"
        titleOne.textAlignment = .center
        titleOne.font = UIFont.systemFont(ofSize: ((view.frame.width / 375) * 30), weight: 0.5)
        titleOne.adjustsFontSizeToFitWidth = true
        titleOne.textColor = UIColor.white
        view.addSubview(titleOne)
        
        titleTwo = UILabel(frame: Utils.rRect(rx: 33, ry: 237.5, rw: 310, rh: 27))
        titleTwo.text = "Just let us know your name,"
        titleTwo.textAlignment = .center
        titleTwo.font = UIFont.systemFont(ofSize: ((view.frame.width / 375) * 18))
        titleTwo.adjustsFontSizeToFitWidth = true
        titleTwo.textColor = UIColor.white
        view.addSubview(titleTwo)
        
        titleThree = UILabel(frame: Utils.rRect(rx: 33, ry: 260.5, rw: 310, rh: 27))
        titleThree.text = "and welcome to Streamline."
        titleThree.textAlignment = .center
        titleThree.font = UIFont.systemFont(ofSize: ((view.frame.width / 375) * 18))
        titleThree.adjustsFontSizeToFitWidth = true
        titleThree.textColor = UIColor.white
        view.addSubview(titleThree)
        
        inputField = UITextField(frame: Utils.rRect(rx: 58, ry: 305, rw: 253, rh: 45))
        inputField.placeholder = "   Type in your name here!"
        inputField.backgroundColor = UIColor.white
        inputField.layer.cornerRadius = 7
        inputField.textColor = UIColor.black
        inputField.font = Constants.averageSans
        view.addSubview(inputField)
        
        
        submitButton                    = UIButton(frame: Utils.rRect(rx: 58, ry: 370, rw: 253, rh: 35))
        submitButton.layer.cornerRadius = 15
        submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor(Constants.darkPurple, for: .normal)
        submitButton.setTitle("DONE", for: .normal)
        
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        view.addSubview(submitButton)
    }
    
    // Selectors
    @objc
    func submitButtonPressed() {
        // This is never nil
        let username = inputField.text!
        if username != "" {
            DB.currentUser.username = username
            DB.updateUsername(user: DB.currentUser)
            self.performSegue(withIdentifier: "usernameToFeed", sender: self)
        }
    }
}
