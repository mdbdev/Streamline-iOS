//
//  ViewControllerExtension.swift
//  MDBSocials
//
//  Created by Stephen Jayakar on 9/26/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

// Makes it so when you tap outside of keyboard, it's dismissed (not sure why this isn't enabled by default)
extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
