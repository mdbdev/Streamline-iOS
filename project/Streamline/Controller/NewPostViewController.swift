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
    var results: [SPTPartialTrack] = []
    var resultsTableView: UITableView!
    var selectedResult: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func updateResults() {
        resultsTableView.reloadData()
    }
    
    // Selectors
    func shareButtonPressed() {
        if (selectedResult >= 0 && selectedResult < results.count) {
            let track = results[selectedResult]
            let u = DB.currentUser!
            let artist = (track.artists[0] as! SPTPartialArtist).name

            let post = Post(uid: u.uid,
                            username: u.username,
                            timePosted: Date().timeIntervalSince1970,
                            trackId: track.identifier,
                            songTitle: track.name,
                            artist: artist!,
                            imageUrl: track.album.largestCover.imageURL.absoluteString)
            
            DB.createPost(post: post, user: DB.currentUser)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // For now only gets the first track that comes up
    func searchSpotify() {
        let songTitle = searchBar.text!
        
        SPTSearch.perform(withQuery: songTitle, queryType: .queryTypeTrack, accessToken: SpotifyAPI.session.accessToken) { (error: Error?, result: Any?) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let r = result as? SPTListPage {
                    if let items = r.items {
                        self.results = items as! [SPTPartialTrack]
                        self.updateResults()
                    }
                }
            }
        }
    }
}

extension NewPostViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // UITableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedResult = indexPath.row
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    // TODO: Only gets one artist
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
        cell.awakeFromNib()
        let song = results[indexPath.row]
        cell.songTitle.text = song.name
        cell.artist.text = (song.artists[0] as! SPTPartialArtist).name
        return cell
    }
    
    // UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSpotify()
    }
}
