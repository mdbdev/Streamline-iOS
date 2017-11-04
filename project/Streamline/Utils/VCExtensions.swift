//
//  ViewControllerExtension.swift
//  MDBSocials
//
//  Created by Stephen Jayakar on 9/26/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

extension UIView {
    func rRect(rx: CGFloat, ry: CGFloat,
               rw: CGFloat, rh: CGFloat) -> CGRect {
        // magic numbers for iPhone 6/7 relative coords
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let w: CGFloat = 375
        let h: CGFloat = 667
        let x: CGFloat = (rx / w) * screenWidth
        let y: CGFloat = (ry / h) * screenHeight
        
        let width: CGFloat = (rw / w) * screenWidth
        let height: CGFloat = (rh / h) * screenHeight
        
        print(x, y, width, height)
        
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UIViewController {
    // creating a relative rectangle for specific mapping from Figma mockup
    func rRect(rx: CGFloat, ry: CGFloat,
               rw: CGFloat, rh: CGFloat) -> CGRect {
        // magic numbers for iPhone 6/7 relative coords
        let w: CGFloat = 375
        let h: CGFloat = 667
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        let x: CGFloat = (rx / w) * screenWidth
        let y: CGFloat = (ry / h) * screenHeight
        
        let width: CGFloat = (rw / w) * screenWidth
        let height: CGFloat = (rh / h) * screenHeight
        
        if rw == rh {
            return sRect(sqx: x, sqy: y, sqw: width, sqh: height)
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // creating a relative square, using rRect
    func sRect(sqx: CGFloat, sqy: CGFloat,
               sqw: CGFloat, sqh: CGFloat) -> CGRect {
        let squareDim: CGFloat = min(sqw, sqh)
        let offset: CGFloat = max(sqw, sqh) - squareDim
        let y: CGFloat = sqy + offset/2
        
        return CGRect(x: sqx, y: sqy, width: squareDim, height: squareDim)
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
