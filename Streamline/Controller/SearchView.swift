//
//  TestView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewDelegate {
    func dismissView()
    //func inviteCollaborators(ids: [String])
    //func inviteObserver(withId: String)
    //func getUsers(withPrefix: String, withBlock: @escaping ([User]) -> Void)
}


class SearchView: UIView {
    var delegate: SearchViewDelegate? = nil
    var view: UIView!
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    var shareButton: UIButton!
    var currentUser: User!
    var results: [SPTPartialTrack] = []
    var resultsTableView: UITableView!
    var selectedResult: Int = -1
    
    
    init(frame: CGRect, large: Bool) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        clipsToBounds = true
        view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(view)
        setupSearch()
        setupButtons()
        setupTableView()
    }
    
    
    
    func setupButtons() {
        //view.addSubview(cancelButton)
        shareButton = UIButton(frame: CGRect(x: 0, y: view.frame.height * 0.7, width: view.frame.width, height: view.frame.height * 0.3))
        shareButton.backgroundColor = UIColor(hex: "673AB7")
        shareButton.setTitleColor(UIColor.white, for: .normal)
        shareButton.setTitle("SHARE", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        view.addSubview(shareButton)
    }
    
    func setupSearch() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height : view.frame.height * 0.2))
        searchBar.backgroundColor = UIColor.white
        searchBar.placeholder = "What song do you want to share?"
        searchBar.delegate = self
        view.addSubview(searchBar)
    }
    
    func setupTableView() {
        //let style = UITableViewStyle.grouped
        resultsTableView = UITableView(frame: CGRect(x: 0, y: view.frame.height * 0.2, width: view.frame.width, height: view.frame.height * 0.5))
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.allowsSelection = true
        resultsTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "resultCell")
        view.addSubview(resultsTableView)
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
                            timePosted: Date(),
                            trackId: track.identifier,
                            songTitle: track.name,
                            artist: artist!,
                            imageUrl: track.album.largestCover.imageURL.absoluteString,
                            duration: track.duration)
            
            DB.createPost(post: post, user: DB.currentUser)
            //self.dismiss(animated: true, completion: nil)
            delegate?.dismissView()
        }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchView: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
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
