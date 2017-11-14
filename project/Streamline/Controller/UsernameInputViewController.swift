//
//  UsernameInputViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 11/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import UIKit

class UsernameInputViewController: UIViewController {
    var message: UILabel!
    var inputField: UITextField!
    var submitButton: UIButton!
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = Constants.darkPurple
        
        message = UILabel(frame: Utils.rRect(rx: 27, ry: 69, rw: 322, rh: 187))
        message.text = "Hey, we weren't able to get your name!"
        message.font = Constants.averageSans?.withSize(90)
        message.adjustsFontSizeToFitWidth = true
        message.textColor = UIColor.white
        view.addSubview(message)
        
        inputField = UITextField(frame: Utils.rRect(rx: 39, ry: 302, rw: 255, rh: 45))
        inputField.placeholder = "Type it in here..."
        inputField.backgroundColor = UIColor.white
        inputField.textColor = UIColor.black
        inputField.font = Constants.averageSans
        view.addSubview(inputField)
        
        submitButton = UIButton(frame: Utils.sRect(sqx: 313, sqy: 291, sqw: 60, sqh: 60))
        submitButton.backgroundColor = UIColor.white
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
