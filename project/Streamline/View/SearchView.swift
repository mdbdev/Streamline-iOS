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
        
        layer.cornerRadius = 5
        clipsToBounds = true
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.white
        
        addSubview(view)
        setupSearch()
        setupButtons()
        setupTableView()
    }
    
    
    
    func setupButtons() {
        cancelButton                    = UIButton(frame: Utils.rRect(rx: 28.14, ry: 229.93, rw: 107.33, rh: 31.81))
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderColor  = UIColor(hex: "673AB7").cgColor
        cancelButton.layer.borderWidth  = 2
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitleColor(Constants.darkPurple, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        view.addSubview(cancelButton)
        
        shareButton                     = UIButton(frame: Utils.rRect(rx: 153.18, ry: 229.93, rw: 107.33, rh: 31.81))
        shareButton.layer.cornerRadius  = 15
        shareButton.backgroundColor     = UIColor(hex: "673AB7")
        shareButton.setTitleColor(UIColor.white, for: .normal)
        shareButton.setTitle("SHARE", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        view.addSubview(shareButton)
    }
    
    func setupSearch() {
        
        searchBar                 = UISearchBar(frame: Utils.rRect(rx: 10, ry: 16, rw: 275, rh: 44))
        searchBar.searchBarStyle  = .minimal
        searchBar.backgroundColor = UIColor.white
        
        searchBar.placeholder     = "Search a song"
        
        searchBar.delegate = self
        view.addSubview(searchBar)
    }
    
    func setupTableView() {
        resultsTableView                 = UITableView(frame: CGRect(x: 0, y: view.frame.height * 0.25, width: view.frame.width, height: view.frame.height * 0.5))
        resultsTableView.delegate        = self
        resultsTableView.dataSource      = self
        resultsTableView.allowsSelection = true
        resultsTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "resultCell")
        view.addSubview(resultsTableView)
    }
    
    func updateResults() {
        resultsTableView.reloadData()
    }
    
    // Selectors
    func cancelButtonPressed() {
        delegate?.dismissView()
    }
    
    func shareButtonPressed() {
        if (selectedResult >= 0 && selectedResult < results.count) {
            let track   = results[selectedResult]
            let u       = DB.currentUser!
            let artist  = (track.artists[0] as! SPTPartialArtist).name
            
            let post    = Post(uid: u.uid,
                            username: u.username,
                            timePosted: Date().timeIntervalSince1970,
                            trackId: track.identifier,
                            songTitle: track.name,
                            artist: artist!,
                            imageUrl: track.album.largestCover.imageURL.absoluteString,
                            profileImageURL: DB.currentUser.imageUrl)
            
            DB.createPost(post: post, user: DB.currentUser)
            u.createPost(pid: post.pid, timePosted: post.timePosted)
            delegate?.dismissView()
        }
    }
    
    func searchSpotify() {
        let songTitle = searchBar.text!
        DispatchQueue.main.async {
            SPTSearch.perform(withQuery: songTitle, queryType: .queryTypeTrack, accessToken: SpotifyAPI.session.accessToken) { (error: Error?, result: Any?) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        if let r = result as? SPTListPage {
                            if let items = r.items {
                                self.results = items as! [SPTPartialTrack]
                                if songTitle != self.searchBar.text! {
                                    self.updateResults()
                                }
                            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    
    // UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSpotify()
    }
}
