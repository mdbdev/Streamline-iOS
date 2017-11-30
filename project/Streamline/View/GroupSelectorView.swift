//
//  GroupSelectorView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 11/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation

protocol GroupSelectorViewDelegate {
    
}

class GroupSelectorView:UIView {
    var delegate: GroupSelectorViewDelegate? = nil
    var view: UIView!
    
    var returnButton : UIButton!
    var groupsPicker : UIPickerView!
    
    init(frame: CGRect, large: Bool) {
        print(DB.currentUser.imageUrl)
        
        super.init(frame: frame)
        
        layer.cornerRadius  = 5
        clipsToBounds       = true
        view = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        view.layer.cornerRadius = 4
        view.backgroundColor    = .white
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons() {
        
    }
    
    func setupPicker() {
        
        groupsPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.7))
        //groupsPicker.dataSource = DB.currentUser.groups
    }
    
    
}
