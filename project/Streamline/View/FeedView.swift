//
//  FeedView.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/30/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


// TODO: Rewrite these to actual views rather than extensions
extension FeedViewController {    
    
    func setupUI() {
        setupCollectionView()
        setupBackground()
        setupButton()
        setupLabel()
        setupNowPlaying()
    }
    
    func setupNowPlaying() {
        nowPlayingButton = UIButton(frame: rRect(rx: 0, ry: 609, rw: 375, rh: 60))
        nowPlayingButton.backgroundColor = UIColor.black
        nowPlayingButton.addTarget(self, action: #selector(nowPlayingButtonPressed), for: .touchUpInside)
        view.addSubview(nowPlayingButton)
        
        nowPlayingLabel = UILabel(frame: rRect(rx: 0, ry: 609, rw: 375, rh: 60))
        nowPlayingLabel.textColor = UIColor.white
        nowPlayingLabel.adjustsFontSizeToFitWidth = true
        nowPlayingLabel.font = Constants.averageSans
        view.addSubview(nowPlayingLabel)
    }
    
    func setupBackground() {
        view.backgroundColor = Constants.cvBackground
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // TODO: Change these to match the figma
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        postCollectionView = UICollectionView(frame: rRect(rx: 21, ry: 69, rw: 334, rh: 541), collectionViewLayout: layout)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.backgroundColor = Constants.cvBackground
        view.addSubview(postCollectionView)
    }
    
    func setupButton() {
        postButton = UIButton(frame: rRect(rx: 328, ry: 26, rw: 20, rh: 20))
        // TODO: Change this to an image that's in the Figma
        postButton.setTitle("+", for: .normal)
        postButton.setTitleColor(UIColor(hex: "311b92"), for: .normal)
        postButton.backgroundColor = UIColor.white
        
        postButton.backgroundImage(for: .normal)
        postButton.setBackgroundImage(#imageLiteral(resourceName: "PostButton"), for: .normal)
        
        
        postButton.backgroundColor = .clear
        postButton.layer.cornerRadius = 1
        postButton.layer.borderWidth = 2
        postButton.layer.borderColor = UIColor(hex: "311b92").cgColor
        
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        view.addSubview(postButton)
        DB.currentUser.getPID {
            if DB.currentUser.pid != ""{
                self.postButton.isEnabled = false
            }
        }
        
        
        
        logoutButton = UIButton(frame: rRect(rx: 15, ry: 30, rw: 74, rh: 22))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor(hex: "737171"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    func setupLabel() {
        discoverLabel = UILabel(frame: CGRect(x: 0, y: 25, width: view.frame.width, height: 44))
        
        discoverLabel.textColor = UIColor(hex: "311b92")
        discoverLabel.text = "DISCOVER"
        discoverLabel.textAlignment = .center
        //discoverLabel.font = UIFont(name: "AverageSans-Regular", size: 100)
        
        discoverLabel.font = Constants.averageSans?.withSize(20)
        discoverLabel.font = UIFont.systemFont(ofSize: 30)
        
        view.addSubview(discoverLabel)
    }
}
