//
//  CreatePostView.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/25/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import UIKit

extension NewPostViewController {
    func setupUI() {
        setupSearch()
        setupButtons()
    }
    
    // Setup Functions
    func setupView() {
        view.backgroundColor = UIColor(hex: "512DA8")
    }
    func setupButtons() {
        cancelButton = UIButton(frame: rRect(rx: 46, ry: 96, rw: 131, rh: 35))
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitleColor(UIColor(hex: "673AB7"), for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        view.addSubview(cancelButton)
        shareButton = UIButton(frame: rRect(rx: 195, ry: 96, rw: 131, rh: 35))
        shareButton.backgroundColor = UIColor(hex: "673AB7")
        shareButton.setTitleColor(UIColor.white, for: .normal)
        shareButton.setTitle("SHARE", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        view.addSubview(shareButton)
    }
    
    func setupSearch() {
        searchBar = UISearchBar(frame: rRect(rx: 46, ry: 28, rw: 284, rh: 49))
        searchBar.backgroundColor = UIColor.white
        searchBar.placeholder = "What song do you want to share?"        
        view.addSubview(searchBar)
    }
}
