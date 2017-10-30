//
//  NowPlayingView.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


extension NowPlayingViewController {
    func setupUI() {
        backButton = UIButton(frame: rRect(rx: 26, ry: 26, rw: 40, rh: 40))
        backButton.setImage(UIImage(named: "arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(backButton)
        
        albumImage = UIImageView(frame: rRect(rx: 66, ry: 136, rw: 245, rh: 245))
        albumImage.image = UIImage(named: "albumPlaceholder")
        albumImage.contentMode = .scaleAspectFit
        view.addSubview(albumImage)
        
        songName = UILabel(frame: rRect(rx: 65, ry: 387, rw: 245, rh: 25))
        songName.text = "Song"
        songName.adjustsFontSizeToFitWidth = true
        songName.textColor = Constants.weirdGreen
        songName.font = Constants.averageSans?.withSize(20)
        view.addSubview(songName)
        
        artistName = UILabel(frame: rRect(rx: 65, ry: 412, rw: 245, rh: 25))
        artistName.text = "Artist"
        artistName.adjustsFontSizeToFitWidth = true
        artistName.textColor = Constants.weirdGreen
        artistName.font = Constants.averageSans?.withSize(15)
        view.addSubview(artistName)
    }
}
