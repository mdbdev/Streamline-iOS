//
//  LoginViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/18/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

// TODO: Logging in, then out, then in again crashes!
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
//        let p = Post(uid: "asdklfjsakldfjsd", username: "Annie", timePosted: Date(), trackId: "6aiHF2IbJr6lG4Vu9em8KF", songTitle: "Believer- Kaskade Remix", artist: "Imagine Dragons", imageUrl: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwjoiva84YzXAhUr4YMKHbxKAtAQjRwIBw&url=https%3A%2F%2Fwww.amazon.com%2FEvolve-Imagine-Dragons%2Fdp%2FB07143J5MM&psig=AOvVaw1v4RINQVGZpIRLThTPj3lU&ust=1509054834778931")
//        let u = User(uid: "asdklfjsakldfjsd")
//        DB.createPost(post: p, user: u)
        super.viewDidLoad()
        
        //Add observer to listen for spotify login success
        NotificationCenter.default.addObserver(self, selector: #selector(toFeedView), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        setupAuth()
        if(UserDefaults.standard.value(forKey: "SpotifySession") != nil) {
            toFeedView()
        } else {
            setupUI()
        }
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
            if self.session.isValid() {
                SpotifyAPI.session = self.session
                createUser()
            } else {
                setupUI()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Assume segue destination is feed
        let dest = segue.destination as! FeedViewController
        dest.session = self.session
        dest.auth = self.auth
    }
    
    //Spotify Functions
    
    func createUser(){
        user = User(uid: self.session.canonicalUsername)
        DB.currentUser = user
        //Determine if the proper name to display
        SpotifyWeb.getUserDisplayName(accessToken: self.session.accessToken, withBlock: { username in
            self.user.username = username
            //DB.createUser(uid: self.session.canonicalUsername, username: self.user.username)
            DB.createUser(uid: self.session.canonicalUsername, username: self.user.username, withBlock: {
                self.performSegue(withIdentifier: "toFeed", sender: self)
            })
        })
    }
    
}
