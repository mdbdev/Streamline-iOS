//
//  SpotifyWeb.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 10/16/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
import Alamofire


// TODO: We definitely need to reconsider the existence of this class
class SpotifyWeb {
    // Get the users display name with the spotify web api
    static func getUserDisplayName(accessToken: String, withBlock: @escaping (String, String) -> ()) {
        print(accessToken)
        let headers = ["Accept": "application/json",
                       "Authorization": "Bearer \(accessToken)"]
        Alamofire.request("https://api.spotify.com/v1/me", headers: headers).responseJSON(completionHandler: { (response) in
            let initialJsonResponse = response.result.value as? NSDictionary
            if let jsonResponse = initialJsonResponse {
                let username : String = "Anonymous User"
                print((jsonResponse["images"] as! NSArray).count)
                var imageURL = ""
                if (jsonResponse["images"] as! NSArray).count == 0 {
                    imageURL = Constants.imageURL
                } else {
                    imageURL = ((jsonResponse["images"] as! NSArray)[0] as! NSDictionary)["url"] as! String
                }
                let usernameJson = jsonResponse["display_name"]
                if let x = jsonResponse["display_name"] as? String {
                    withBlock(x, imageURL)
                } else {
                    withBlock(username, imageURL)
                }
            }
        })
    }
}
