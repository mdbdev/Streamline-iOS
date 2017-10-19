//
//  DemoViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import AVFoundation
import Alamofire

class DemoViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var authenticatedUser: User!
    
    var loginButton: UIButton!
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var user: SPTUser!
    
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(DemoViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        setupAuth()
        setupBackground()
        setupButton()
    }

    // Setup Functions
    func setupAuth() {
        let redirectURL = "Streamline://returnAfterLogin" // put your redirect URL here
        let clientID = "e4603453585849a6ad176d0fb81acd97" // put your client ID here
        auth.redirectURL     = URL(string: "\(redirectURL)")
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    func setupBackground() {
        view.backgroundColor = UIColor.black
    }
    
    func setupButton() {
        loginButton = UIButton(frame: CGRect(x: 92, y: 318, width: 191, height: 30))
        loginButton.setTitle("Login with Spotify", for: .normal)
        loginButton.backgroundColor = UIColor.green
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            
            
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
        
    }
    
    @objc
    func updateAfterFirstLogin () {
        loginButton.isHidden = true
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializePlayer(authSession: session)
            self.loginButton.isHidden = true
            createUser()
            //Get the display name
            SpotifyWeb.getUserDisplayName(accessToken: self.session.accessToken, withBlock: { username in
                print(username)
                if username == "null" {
                    self.authenticatedUser.username = self.session.canonicalUsername
                } else {
                    self.authenticatedUser.username = username
                }
                DB.createUser(username: self.authenticatedUser.username)
                self.authenticatedUser.getPID()
            })
        }
    }
    
    //Create the user and check if they are from facebook or native spotify user
    func createUser(){
        
        //print(self.session.canonicalUsername)
        authenticatedUser = User(uid: self.session.canonicalUsername)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:2ISSQPb9LHHiV6ng2NXosL", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            
        })
        
    }

    
    // Selectors
    @objc
    func loginButtonPressed() {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // handle errors
            }
        }
    }
}


