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
    
    
    //Get the user display name with cURL command
    //cURL format : curl -X GET "https://api.spotify.com/v1/me" -H "Authorization: Bearer {your access token}"
    static func getUserDisplayName(accessToken: String, withBlock: @escaping (String) -> ()) {
        print(accessToken)
        let headers = ["Accept": "application/json",
                       "Authorization": "Bearer \(accessToken)"]
        Alamofire.request("https://api.spotify.com/v1/me", headers: headers).responseJSON(completionHandler: { (response) in
            let jsonResponse = response.result.value as! NSDictionary
            var username : String = "Anonymous User"
            var usernameJson = jsonResponse["display_name"]
            print(usernameJson)
            if let x = jsonResponse["display_name"] as? String {
                withBlock(x)
            } else {
                withBlock(username)
            }
        })
    }
}
