//
//  ProfileViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 11/17/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var subView: ProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView = ProfileView(frame: view.frame)
        view.addSubview(subView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
