//
//  ViewControllerExtension.swift
//  MDBSocials
//
//  Created by Stephen Jayakar on 9/26/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

//Used for seek bar scrubbing
extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
