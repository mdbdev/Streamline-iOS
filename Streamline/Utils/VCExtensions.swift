//
//  ViewControllerExtension.swift
//  MDBSocials
//
//  Created by Stephen Jayakar on 9/26/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

extension UIViewController {
    // creating a relative rectangle for my specific mapping in XD
    func rRect(rx: CGFloat, ry: CGFloat,
               rw: CGFloat, rh: CGFloat) -> CGRect {
        // magic numbers for iPhone 6/7 relative coords
        let w: CGFloat = 375
        let h: CGFloat = 667
        let x: CGFloat = (rx / w) * view.frame.width
        let y: CGFloat = (ry / h) * view.frame.height
        let width: CGFloat = (rw / w) * view.frame.width
        let height: CGFloat = (rh / h) * view.frame.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func warning(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
