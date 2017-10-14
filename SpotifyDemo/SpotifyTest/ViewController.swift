//
//  ViewController.swift
//  SpotifyTest
//
//  Created by Vineeth Yeevani on 10/13/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation

class ViewController: UIViewController {
    
    //Setup the UI elements
    var loginButton: UIButton!
    
    
    
    //Spotify Variables
    var loginUrl: URL!
    var auth = SPTAuth.defaultInstance()!
    var session : SPTSession!
    var player : SPTAudioStreamingController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpotify()
        setupUI()
        
        //Setup the notification center recieve elements post-login
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
    }
    
    //Setup the login button element
    func setupUI(){
        loginButton = UIButton(frame: CGRect(x: 0, y: view.frame.height * 0.7, width: view.frame.width, height: view.frame.height * 0.1))
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginSequence), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    //Setup the spotify variables for the login
    func setupSpotify(){
        auth.clientID = Constants.clientID
        auth.redirectURL = Constants.redirectURL
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    //start login sequence
    @objc func loginSequence(){
        print("login sequence init")
        UIApplication.shared.open(loginUrl, options: [:]) { (opened) in
            if self.auth.canHandle(self.auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
    /* ------------------
       Post login methods
       ------------------ */
    
    //Handle the update after login
    @objc func updateAfterFirstLogin(){
        
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    //Start the player
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
}

extension ViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
}

