//
//  SpotifyWeb.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 10/16/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
import Alamofire

class SpotifyWeb {
    
    //Get the users display name with the spotify web api
    static func getUserDisplayName(accessToken: String, withBlock: @escaping (String, String) -> ()) {
        print(accessToken)
        let headers = ["Accept": "application/json",
                       "Authorization": "Bearer \(accessToken)"]
        Alamofire.request("https://api.spotify.com/v1/me", headers: headers).responseJSON(completionHandler: { (response) in
            let initialJsonResponse = response.result.value as? NSDictionary
            if let jsonResponse = initialJsonResponse {
                var username : String = "Anonymous User"
                print((jsonResponse["images"] as! NSArray).count)
                var imageURL = ""
                if (jsonResponse["images"] as! NSArray).count == 0 {
                    imageURL = "https://firebasestorage.googleapis.com/v0/b/streamline-b9599.appspot.com/o/defaultprof.png?alt=media&token=5c582f75-8415-4ef5-86eb-2d1063f5684b"
                } else {
                    imageURL = ((jsonResponse["images"] as! NSArray)[0] as! NSDictionary)["url"] as! String
                }
                var usernameJson = jsonResponse["display_name"]
                if let x = jsonResponse["display_name"] as? String {
                    withBlock(x, imageURL)
                } else {
                    withBlock(username, imageURL)
                }
            }
        })
    }
}
