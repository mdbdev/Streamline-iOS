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
    
    var subView: UsernameInputView!
    
    override func viewDidLoad() {
        subView = UsernameInputView(frame: view.frame)
        subView.delegate = self
        view.addSubview(subView)
    }
}

extension UsernameInputViewController: UsernameInputDelegate {
    func submitButtonPressed() {
        // This is never nil
        let username = subView.inputField.text!
        if username != "" {
            DB.currentUser.username = username
            DB.updateUsername(user: DB.currentUser)
            self.performSegue(withIdentifier: "usernameToFeed", sender: self)
        }
    }
}
