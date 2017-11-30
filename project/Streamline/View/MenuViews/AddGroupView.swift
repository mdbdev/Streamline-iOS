//
//  AddGroupView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation

protocol AddGroupViewDelegate {
    func addGroupButtonPressed()
}

class AddGroupView:UIView {
    var delegate: AddGroupViewDelegate? = nil
    var view: UIView!
    
    var groupNameTextField: UITextField!
    var addButton: UIButton!
   
    init(frame: CGRect, large: Bool) {
        print(DB.currentUser.imageUrl)
        
        super.init(frame: frame)
        
        layer.cornerRadius  = 5
        clipsToBounds       = true
        view = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        view.layer.cornerRadius = 4
        view.backgroundColor    = .white
        
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Setup methods
    func setupButtons() {
        addButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.8, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        addButton.layer.cornerRadius = 15
        addButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        addButton.layer.borderWidth  = 2
        
        addButton.backgroundColor = UIColor.white
        addButton.setTitleColor(Constants.darkPurple, for: .normal)
        addButton.setTitle("Add Group", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    func setupEditText() {
        groupNameTextField                    = UITextField(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.47, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        groupNameTextField.layer.cornerRadius = 15
        groupNameTextField.backgroundColor    = UIColor.white
        groupNameTextField.textColor          = Constants.darkPurple
        groupNameTextField.placeholder        = "Enter Group Name: " + DB.currentUser.username
        view.addSubview(groupNameTextField)
    }
    
    func addButtonPressed() {
        delegate?.addGroupButtonPressed()
    }
}

