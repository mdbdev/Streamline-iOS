//
//  LoginViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/18/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    // LoginView
    var subView: LoginView!
    
    // Spotify Elements
    var auth    = SPTAuth.defaultInstance()!
    var session : SPTSession!
    var user    : User!
    var loginUrl: URL?
    
    //Safari View
    var svc     : SFSafariViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer to listen for spotify login success
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toFeedView),
            name    : NSNotification.Name(rawValue: "loginSuccessfull"),
            object  : nil
        )
        
        setupAuth()
        
        // Login view setup
        subView = LoginView(frame: view.frame)
        subView.delegate = self
        view.addSubview(subView)
        
        // Checks the user defaults for existing spotify sessions
        if (UserDefaults.standard.value(forKey: "SpotifySession") != nil) {
            toFeedView()
        }
    }
    
    
    // Setup SPTAuth
    func setupAuth() {
        let redirectURL      = SpotifyAPI.redirectURL // redirectURL
        let clientID         = SpotifyAPI.clientID // clientID
        auth.redirectURL     = URL(string: "\(redirectURL)")
        auth.clientID        = clientID
        auth.requestedScopes = [
            SPTAuthStreamingScope,
            SPTAuthPlaylistReadPrivateScope,
            SPTAuthPlaylistModifyPublicScope,
            SPTAuthPlaylistModifyPrivateScope,
            SPTAuthUserReadPrivateScope
        ]
        loginUrl             = auth.spotifyWebAuthenticationURL()
        SpotifyAPI.auth      = auth
    }
    
    // Segue to feed view
    func toFeedView(){
        if svc != nil {
            if svc.isViewLoaded {
                print(UIApplication.topViewController())
            }
        }
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
    
    // Creates the user if they don't exist in database already
    func createUser() {
        DB.fetchUser(uid: self.session.canonicalUsername) { (user) in
            // User already exists in database
            if let user = user {
                DB.currentUser = user
                let feedView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController")
                UIApplication.topViewController()?.present(feedView, animated: true, completion: nil)
            } else {
                self.user = User(uid: self.session.canonicalUsername, pid: "", username: "", imageUrl: "", timePosted: nil)
                DB.currentUser = self.user
                SpotifyWeb.getUserDisplayName(accessToken: self.session.accessToken, withBlock: { (username, imageURL) in
                    self.user.username = username
                    self.user.imageUrl = imageURL
                    let usernameView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UsernameInputViewController")
                    DB.createUser(uid: self.session.canonicalUsername,
                                  username: self.user.username,
                                  userprofile: imageURL,
                                  withBlock: {
                                    UIApplication.topViewController()?.present(usernameView, animated: true, completion: nil)
                    })
                })
            }
        }
    }
}

//Managing button presses in the LoginView
extension LoginViewController: LoginViewDelegate {
    func connectButtonPressed() {
        svc = SFSafariViewController(url: self.loginUrl!)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
}

extension LoginViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
