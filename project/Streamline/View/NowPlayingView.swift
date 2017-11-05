//
//  NowPlayingView.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


class NowPlayingView: UIView {
    var backButton: UIButton!
    var albumImage: UIImageView!
    var songName: UILabel!
    var artistName: UILabel!
    var slider: UISlider!
    var playButton: UIButton!
    var forwardButton: UIButton!
    var backwardButton: UIButton!
    var delegate: NowPlayingViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backButton = UIButton(frame: Utils.rRect(rx: 26, ry: 26, rw: 40, rh: 40))
        backButton.setImage(UIImage(named: "arrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addSubview(backButton)
        
        albumImage = UIImageView(frame: Utils.rRect(rx: 66, ry: 136, rw: 245, rh: 245))
        albumImage.image = UIImage(named: "albumPlaceholder")
        albumImage.contentMode = .scaleAspectFit
        addSubview(albumImage)
        
        songName = UILabel(frame: Utils.rRect(rx: 65, ry: 387, rw: 245, rh: 25))
        songName.text = "Song"
        songName.adjustsFontSizeToFitWidth = true
        songName.textColor = Constants.weirdGreen
        songName.font = Constants.averageSans?.withSize(20)
        addSubview(songName)
        
        artistName = UILabel(frame: Utils.rRect(rx: 65, ry: 412, rw: 245, rh: 25))
        artistName.text = "Artist"
        artistName.adjustsFontSizeToFitWidth = true
        artistName.textColor = Constants.weirdGreen
        artistName.font = Constants.averageSans?.withSize(15)
        addSubview(artistName)
        
        slider = UISlider(frame: Utils.rRect(rx: 26, ry: 447, rw: 328, rh: 20))
        slider.isContinuous = false
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderChanging), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderNoLongerChanging), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderNoLongerChanging), for: .touchUpOutside)
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.minimumTrackTintColor = UIColor(hex: "d1c4e9")
        slider.maximumTrackTintColor = UIColor.black
        // TODO: Have to change the maximum and minimum image to match the figma
        addSubview(slider)
        
        playButton = UIButton(frame: Utils.rRect(rx: 166, ry: 518, rw: 43, rh: 43))
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        addSubview(playButton)
        
        forwardButton = UIButton(frame: Utils.rRect(rx: 268, ry: 522, rw: 35, rh: 35))
        forwardButton.addTarget(self, action: #selector(forwardButtonPressed), for: .touchUpInside)
        forwardButton.setBackgroundImage(#imageLiteral(resourceName: "right skip"), for: .normal)
        addSubview(forwardButton)
        
        backwardButton = UIButton(frame: Utils.rRect(rx: 72, ry: 522, rw: 35, rh: 35))
        backwardButton.addTarget(self, action: #selector(backwardButtonPressed), for: .touchUpInside)
        backwardButton.setBackgroundImage(#imageLiteral(resourceName: "left skip"), for: .normal)
        addSubview(backwardButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    func playButtonPressed() {
        self.delegate?.playButtonPressed()
        if SpotifyAPI.player.playbackState.isPlaying {
            playButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
    
    func forwardButtonPressed() {
        self.delegate?.forwardButtonPressed()
    }
    
    func backwardButtonPressed() {
        self.delegate?.backwardButtonPressed()
    }
    
    func sliderChanging() {
        self.delegate?.sliderChanging()
    }
    
    func sliderNoLongerChanging() {
        self.delegate?.sliderNoLongerChanging()
    }
}

protocol NowPlayingViewDelegate {
    func playButtonPressed()
    func backButtonPressed()
    func forwardButtonPressed()
    func backwardButtonPressed()
    func sliderChanging()
    func sliderNoLongerChanging()
}
