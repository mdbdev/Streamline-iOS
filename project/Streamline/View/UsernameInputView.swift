//
//  UsernameInputView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation

class UsernameInputView: UIView {
    var titleOne: UILabel!
    var titleTwo: UILabel!
    var titleThree: UILabel!
    var inputField: UITextField!
    var submitButton: UIButton!
    var delegate: UsernameInputDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = Constants.darkPurple
        
        titleOne = UILabel(frame: Utils.rRect(rx: 0, ry: 193, rw: 375, rh: 50))
        titleOne.text = "Almost finished!"
        titleOne.textAlignment = .center
        titleOne.font = UIFont.systemFont(ofSize: ((frame.width / 375) * 30), weight: 0.5)
        titleOne.adjustsFontSizeToFitWidth = true
        titleOne.textColor = UIColor.white
        addSubview(titleOne)
        
        titleTwo = UILabel(frame: Utils.rRect(rx: 33, ry: 237.5, rw: 310, rh: 27))
        titleTwo.text = "Just let us know your name,"
        titleTwo.textAlignment = .center
        titleTwo.font = UIFont.systemFont(ofSize: ((frame.width / 375) * 18))
        titleTwo.adjustsFontSizeToFitWidth = true
        titleTwo.textColor = UIColor.white
        addSubview(titleTwo)
        
        titleThree = UILabel(frame: Utils.rRect(rx: 33, ry: 260.5, rw: 310, rh: 27))
        titleThree.text = "and welcome to Streamline."
        titleThree.textAlignment = .center
        titleThree.font = UIFont.systemFont(ofSize: ((frame.width / 375) * 18))
        titleThree.adjustsFontSizeToFitWidth = true
        titleThree.textColor = UIColor.white
        addSubview(titleThree)
        
        inputField = UITextField(frame: Utils.rRect(rx: 58, ry: 305, rw: 253, rh: 45))
        inputField.placeholder = "   Type in your name here!"
        inputField.backgroundColor = UIColor.white
        inputField.layer.cornerRadius = 7
        inputField.textColor = UIColor.black
        inputField.font = Constants.averageSans
        addSubview(inputField)
        
        
        submitButton                    = UIButton(frame: Utils.rRect(rx: 58, ry: 370, rw: 253, rh: 35))
        submitButton.layer.cornerRadius = 15
        submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor(Constants.darkPurple, for: .normal)
        submitButton.setTitle("DONE", for: .normal)
        
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        addSubview(submitButton)
    }
    
    @objc
    func submitButtonPressed() {
        self.delegate?.submitButtonPressed()
    }
    
}

protocol UsernameInputDelegate {
    func submitButtonPressed()
}
