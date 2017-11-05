//
//  LoginViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/18/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //LoginView
    var subView: LoginView!
    
    // Spotify Elements
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var user: User!
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer to listen for spotify login success
        NotificationCenter.default.addObserver(self, selector: #selector(toFeedView), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        setupAuth()
        
        //Login view setup
        subView = LoginView(frame: view.frame)
        subView.delegate = self
        view.addSubview(subView)
        
        //Checks the user defaults for existing spotify sessions
        if (UserDefaults.standard.value(forKey: "SpotifySession") != nil) {
            toFeedView()
        }
    }
    
    
    //Setup SPTAuth
    func setupAuth() {
        let redirectURL = SpotifyAPI.redirectURL // redirectURL
        let clientID = SpotifyAPI.clientID // clientID
        auth.redirectURL     = URL(string: "\(redirectURL)")
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserReadPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
        SpotifyAPI.auth = auth
    }
    
    //Segue to feed view
    func toFeedView(){
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            if let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession{
                self.session = firstTimeSession
                if self.session.isValid() {
                    SpotifyAPI.session = self.session
                    createUser()
                } else {
                    subView.setupUI()
                }
            }
            else {
                print("Login Cancelled")
            }
        }
    }
    
    //Setup the segue to feed view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Assume segue destination is feed
        let dest = segue.destination as! FeedViewController
        
    }
    
    //Creates the user if they don't exist in database already
    func createUser(){
        user = User(uid: self.session.canonicalUsername)
        DB.currentUser = user
        //Determine if the proper name to display
        SpotifyWeb.getUserDisplayName(accessToken: self.session.accessToken, withBlock: { (username, imageURL) in
            self.user.username = username
            self.user.imageUrl = imageURL
            DB.createUser(uid: self.session.canonicalUsername, username: self.user.username, userprofile: imageURL, withBlock: {
                self.performSegue(withIdentifier: "toFeed", sender: self)
            })
        })
    }
}

//Managing button presses in the LoginView
extension LoginViewController: LoginViewDelegate {
    func connectButtonPressed() {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // handle errors
            }
        }
    }
}
