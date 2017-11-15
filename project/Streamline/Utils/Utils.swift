//
//  File.swift
//  Streamline
//
//  Created by Annie Tang on 11/4/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class Utils {
    // creating a relative rectangle for specific mapping from Figma mockup
    static func rRect(rx: CGFloat, ry: CGFloat,
               rw: CGFloat, rh: CGFloat) -> CGRect {
        // magic numbers for iPhone 6/7 relative coords
        let w: CGFloat   = 375
        let h: CGFloat   = 667
        let screenSize   = UIScreen.main.bounds
        let screenWidth  = screenSize.width
        let screenHeight = screenSize.height
        
        
        let x: CGFloat = (rx / w) * screenWidth
        let y: CGFloat = (ry / h) * screenHeight
        
        let width : CGFloat = (rw / w) * screenWidth
        let height: CGFloat = (rh / h) * screenHeight
        
        if rw == rh {
            return sRect(sqx: x, sqy: y, sqw: width, sqh: height)
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // creating a relative square, using rRect
    static func sRect(sqx: CGFloat, sqy: CGFloat,
               sqw: CGFloat, sqh: CGFloat) -> CGRect {
        let squareDim: CGFloat = min(sqw, sqh)
        let offset   : CGFloat = max(sqw, sqh) - squareDim
        let y        : CGFloat = sqy + offset/2
        
        return CGRect(x: sqx, y: y, width: squareDim, height: squareDim)
    }
    
    // presents popup alert
    static func createAlert(warningMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: "WARNING:",
                                      message: warningMessage,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }

}




