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
        super.viewDidLoad()
        
        //Add observer to listen for spotify login success
        NotificationCenter.default.addObserver(self, selector: #selector(toFeedView), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        
        setupBackground()
        setupLogo()
        setupAuth()
        setupButton()
    }
    
    /* UI Setup Functions */
    
    func setupBackground() {
        view.backgroundColor = Constants.darkPurple
    }
    
    func setupLogo() {
        logoImage = UIImageView(frame: rRect(rx: 20, ry: 216, rw: 358, rh: 79))
        logoImage.contentMode = .scaleAspectFit
        logoImage.image = UIImage(named: "LogoBackground")
        view.addSubview(logoImage)
        
        logoText = UILabel(frame: rRect(rx: 30, ry: 230, rw: 328, rh: 33))
        logoText.text = "STREAMLINE"
        logoText.textColor = Constants.darkPurple
        logoText.font = UIFont(name: "Helvetica", size: 45)
        view.addSubview(logoText)
    }
    
    func setupButton() {
        connectButton = UIButton(frame: rRect(rx: 75, ry: 324, rw: 239, rh: 45))
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        connectButton.setTitle("CONNECT WITH SPOTIFY", for: .normal)
        connectButton.setTitleColor(Constants.darkPurple, for: .normal)
        connectButton.layer.cornerRadius = 15
        connectButton.backgroundColor = UIColor.white
        view.addSubview(connectButton)
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
            // TODO: Send the current user -> feed
        }
    }
    
    
    //Spotify Functions
    
    func createUser(){
        user = User(uid: self.session.canonicalUsername)
        
        //Determine if the proper name to display
        SpotifyWeb.getUserDisplayName(accessToken: self.session.accessToken, withBlock: { username in
            self.user.username = username
            self.user.getPID()
            DB.createUser(uid: self.session.canonicalUsername, username: self.user.username)
        })
    }
    
}
