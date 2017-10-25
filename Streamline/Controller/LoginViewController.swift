//
//  LoginViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/18/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //UI Elements
    var logoImage: UIImageView!
    var logoText: UILabel!
    var connectButton: UIButton!
    
    //Spotify Elements
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var user: User!
    var loginUrl: URL?
    
    override func viewDidLoad() {
        // Create sample post
//        let p = Post(uid: "Ajay", timePosted: Date(), trackId: "4ZAerT2NicBmzZ4VkpmWEn", songTitle: "Free Fall", artist: "Illenium", imageUrl: "")
//        let u = User(uid: "hello")
//        DB.createPost(post: p, user: u)
        super.viewDidLoad()
        
        //Add observer to listen for spotify login success
        NotificationCenter.default.addObserver(self, selector: #selector(toFeedView), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        setupUI()
        setupAuth()
    }
    
    
    /* Spotify Connect Functions */
    
    func setupAuth() {
        let redirectURL = SpotifyAPI.redirectURL // redirectURL
        let clientID = SpotifyAPI.clientID // clientID
        auth.redirectURL     = URL(string: "\(redirectURL)")
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserReadPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    // Selectors
    // TODO: This crashes if you don't authenticate successfully 
    func connectButtonPressed() {
        // This is where we will try connecting with Spotify
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // handle errors
            }
        }
    }
    
    func toFeedView(){
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            createUser()
            self.performSegue(withIdentifier: "toFeed", sender: self)
        }
    }
    
    
    //Spotify Functions
    
    func createUser(){
        user = User(uid: self.session.canonicalUsername)
        
        //Determine if the proper name to display
        SpotifyWeb.getUserDisplayName(accessToken: self.session.accessToken, withBlock: { username in
            self.user.username = username
            DB.createUser(uid: self.session.canonicalUsername, username: self.user.username)
        })
    }
    
}
