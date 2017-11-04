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
        nowPlayingButton = UIButton(frame: Utils.rRect(rx: 0, ry: 609, rw: 375, rh: 60))
        nowPlayingButton.backgroundColor = UIColor.white
        nowPlayingButton.addTarget(self, action: #selector(nowPlayingButtonPressed), for: .touchUpInside)
        view.addSubview(nowPlayingButton)
        
        nowPlayingLabel = UILabel(frame: Utils.rRect(rx: 61, ry: 617, rw: 268, rh: 28))
        nowPlayingLabel.textColor = UIColor.black

        nowPlayingLabel.adjustsFontSizeToFitWidth = true
        nowPlayingLabel.font = Constants.averageSans?.withSize(25)
        view.addSubview(nowPlayingLabel)
        
        nowPlayingArtist = UILabel(frame: Utils.rRect(rx: 61, ry: 644, rw: 268, rh: 16))
        nowPlayingArtist.textColor = UIColor.black
        nowPlayingArtist.adjustsFontSizeToFitWidth = true
        nowPlayingArtist.font = Constants.averageSans?.withSize(15)
        view.addSubview(nowPlayingArtist)
        
        // TODO: Use annie's square function
        nowPlayingImage = UIImageView(frame: Utils.rRect(rx: 8, ry: 617, rw: 47, rh: 47))
        nowPlayingImage.image = UIImage(named: "albumPlaceholder")
        nowPlayingImage.contentMode = .scaleAspectFit
        view.addSubview(nowPlayingImage)
    }
    
    func setupBackground() {
        view.backgroundColor = Constants.cvBackground
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // TODO: Change these to match the figma
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        postCollectionView = UICollectionView(frame: Utils.rRect(rx: 21, ry: 69, rw: 334, rh: 541), collectionViewLayout: layout)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.backgroundColor = Constants.cvBackground
        view.addSubview(postCollectionView)
    }
    
    func setupButton() {
        postButton = UIButton(frame: Utils.rRect(rx: 332, ry: 31, rw: 23, rh: 23))
        
        postButton.setTitle("+", for: .normal)
        postButton.setTitleColor(UIColor(hex: "311b92"), for: .normal)
        postButton.backgroundColor = UIColor.white
        
        postButton.backgroundColor = .clear
        postButton.layer.cornerRadius = 1.5
        postButton.layer.borderWidth = 2.5
        postButton.layer.borderColor = UIColor(hex: "311b92").cgColor
        
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        view.addSubview(postButton)
        
        logoutButton = UIButton(frame: Utils.rRect(rx: 15, ry: 30, rw: 74, rh: 22))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor(hex: "737171"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        logoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(logoutButton)
    }
    
    func setupLabel() {
        discoverLabel = UILabel(frame: Utils.rRect(rx: 0, ry: 20, rw: 375, rh: 44))
        
        discoverLabel.textColor = UIColor(hex: "311b92")
        discoverLabel.text = "DISCOVER"
        discoverLabel.textAlignment = .center
        //discoverLabel.font = UIFont(name: "AverageSans-Regular", size: 100)
        
        discoverLabel.font = Constants.averageSans?.withSize(20)
        discoverLabel.font = UIFont.systemFont(ofSize: 30)
        
        view.addSubview(discoverLabel)
    }
}
