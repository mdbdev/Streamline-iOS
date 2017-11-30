//
//  GroupView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation

import Foundation
protocol GroupSettingsViewDelegate {
    func createButtonPressed()
}

class GroupSettingsView:UIView {
    var delegate: GroupSettingsViewDelegate? = nil
    var view: UIView!
    
    var addButton   : UIButton!
    var createButton: UIButton!
    
    init(frame: CGRect, large: Bool) {
        print(DB.currentUser.imageUrl)
        
        super.init(frame: frame)
        
        layer.cornerRadius  = 5
        clipsToBounds       = true
        view = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        view.layer.cornerRadius = 4
        view.backgroundColor    = .white
        
        addSubview(view)
        setupGroupsButton()
    }
    
    func setupGroupsButton() {
        addButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.1, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        addButton.layer.cornerRadius = 15
        addButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        addButton.layer.borderWidth  = 2
        addButton.backgroundColor    = UIColor.white
        addButton.setTitleColor(Constants.darkPurple, for: .normal)
        addButton.setTitle("ADD GROUP", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        view.addSubview(addButton)
        
        createButton                    = UIButton(frame: CGRect(x : view.frame.width * 0.1, y: view.frame.height * 0.3, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        createButton.layer.cornerRadius = 15
        createButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        createButton.layer.borderWidth  = 2
        createButton.backgroundColor    = UIColor.white
        createButton.setTitleColor(Constants.darkPurple, for: .normal)
        createButton.setTitle("CREATE GROUP", for: .normal)
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        view.addSubview(createButton)
    }
    
    @objc
    func addButtonPressed() {
        
    }
    
    @objc
    func createButtonPressed() {
        delegate?.createButtonPressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
