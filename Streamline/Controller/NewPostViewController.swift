//
//  CreatePostViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/25/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    var shareButton: UIButton!
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // Selectors
    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // For now only gets the first track that comes up
    func shareButtonPressed() {
        let songTitle = searchBar.text!
        SPTSearch.perform(withQuery: songTitle, queryType: .queryTypeTrack, accessToken: SpotifyAPI.session.accessToken) { (error: Error?, result: Any?) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let r = result as? SPTListPage {
                    let track = r.items[0] as! SPTPartialTrack
                    let u = DB.currentUser!
                    let artist = (track.artists[0] as! SPTPartialArtist).name
                    // TODO: Only gets one artist
                    // TODO: Doesn't get image
                    let post = Post(uid: u.uid,
                                    username: u.username,
                                    timePosted: Date(),
                                    trackId: track.identifier,
                                    songTitle: track.name,
                                    artist: artist!,
                                    imageUrl: track.album.largestCover.imageURL.absoluteString)
                    DB.createPost(post: post, user: DB.currentUser)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
