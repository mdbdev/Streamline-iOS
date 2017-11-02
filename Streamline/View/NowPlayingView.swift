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
    var delegate: NowPlayingViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backButton = UIButton(frame: rRect(rx: 26, ry: 26, rw: 40, rh: 40))
        backButton.setImage(UIImage(named: "arrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addSubview(backButton)
        
        albumImage = UIImageView(frame: rRect(rx: 66, ry: 136, rw: 245, rh: 245))
        albumImage.image = UIImage(named: "albumPlaceholder")
        albumImage.contentMode = .scaleAspectFit
        addSubview(albumImage)
        
        songName = UILabel(frame: rRect(rx: 65, ry: 387, rw: 245, rh: 25))
        songName.text = "Song"
        songName.adjustsFontSizeToFitWidth = true
        songName.textColor = Constants.weirdGreen
        songName.font = Constants.averageSans?.withSize(20)
        addSubview(songName)
        
        artistName = UILabel(frame: rRect(rx: 65, ry: 412, rw: 245, rh: 25))
        artistName.text = "Artist"
        artistName.adjustsFontSizeToFitWidth = true
        artistName.textColor = Constants.weirdGreen
        artistName.font = Constants.averageSans?.withSize(15)
        addSubview(artistName)
        
        slider = UISlider(frame: rRect(rx: 26, ry: 447, rw: 328, rh: 20))
        slider.isContinuous = false
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderChanging), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderNoLongerChanging), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderNoLongerChanging), for: .touchUpOutside)
        addSubview(slider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
    
    func sliderChanging() {
        self.delegate?.sliderChanging()
    }
    
    func sliderNoLongerChanging() {
        self.delegate?.sliderNoLongerChanging()
    }
}

protocol NowPlayingViewDelegate {
    func backButtonPressed()
    func sliderChanging()
    func sliderNoLongerChanging()
}
