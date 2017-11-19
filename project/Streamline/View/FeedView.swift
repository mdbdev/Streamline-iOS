//
//  FeedView.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/30/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


// TODO: Rewrite these to actual views rather than extensions
class FeedView: UIView {
    var postCollectionView      : UICollectionView!
    var postButton              : UIButton!
    var postButtonArea          : UIButton!
    var profileButton            : UIButton!
    var discoverLabel           : UILabel!
    var nowPlayingButton        : UIButton!
    var nowPlayingLabel         : UILabel!
    var nowPlayingArtist        : UILabel!
    var nowPlayingImage         : UIImageView!
    var plusSign                : UILabel!
    var delegate                : FeedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        setupCollectionView()
        setupBackground()
        setupButton()
        setupLabel()
        setupNowPlaying()
    }
    
    func setupNowPlaying() {
        nowPlayingButton = UIButton(frame: Utils.rRect(rx: 0, ry: 609, rw: 375, rh: 60))
        nowPlayingButton.backgroundColor    = UIColor.white
        nowPlayingButton.isHidden           = true
        nowPlayingButton.addTarget(self, action: #selector(nowPlayingButtonPressed), for: .touchUpInside)
        addSubview(nowPlayingButton)
        
        nowPlayingLabel             = UILabel(frame: Utils.rRect(rx: 61, ry: 615, rw: 268, rh: 28))
        nowPlayingLabel.textColor   = UIColor.black

        nowPlayingLabel.adjustsFontSizeToFitWidth   = true
        nowPlayingLabel.font                        = Constants.averageSans
        nowPlayingLabel.font                        = UIFont.systemFont(ofSize: ((frame.width / 375) * 18), weight: 0.8)
        nowPlayingLabel.isHidden                    = true
        addSubview(nowPlayingLabel)
        
        nowPlayingArtist = UILabel(frame: Utils.rRect(rx: 61, ry: 637, rw: 268, rh: 28))
        nowPlayingArtist.textColor                  = UIColor.black
        nowPlayingArtist.adjustsFontSizeToFitWidth  = true
        nowPlayingArtist.font                       = UIFont.systemFont(ofSize: ((frame.width / 375) * 16))
        nowPlayingArtist.isHidden                   = true
        addSubview(nowPlayingArtist)
        
        // TODO: Use annie's square function
        nowPlayingImage             = UIImageView(frame: Utils.rRect(rx: 8, ry: 617, rw: 47, rh: 47))
        nowPlayingImage.image       = UIImage(named: "albumPlaceholder")
        nowPlayingImage.contentMode = .scaleAspectFit
        nowPlayingImage.isHidden    = true
        addSubview(nowPlayingImage)
    }
    
    func setupBackground() {
        backgroundColor = Constants.cvBackground
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing       = 8
        layout.minimumInteritemSpacing  = 8
        postCollectionView              = UICollectionView(frame: Utils.rRect(rx: 21, ry: 69, rw: 334, rh: 598), collectionViewLayout: layout)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")

        postCollectionView.backgroundColor = Constants.cvBackground
        addSubview(postCollectionView)
    }
    
    func setupButton() {
        postButton = UIButton(frame: Utils.rRect(rx: 330, ry: 28.5, rw: 26, rh: 26))
        postButton.setBackgroundImage(#imageLiteral(resourceName: "new"), for: .normal)
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        addSubview(postButton)
        
        postButtonArea = UIButton(frame: Utils.rRect(rx: 375 * 0.75, ry: 0, rw: 375 * 0.25, rh: 68))
        postButtonArea.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        addSubview(postButtonArea)
        
        profileButton = UIButton(frame: Utils.rRect(rx: 15, ry: 30, rw: 74, rh: 22))
        profileButton.setTitle("Profile", for: .normal)
        profileButton.setTitleColor(UIColor(hex: "737171"), for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        profileButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addSubview(profileButton)
    }
    
    func setupLabel() {
        discoverLabel = UILabel(frame: Utils.rRect(rx: 0, ry: 20, rw: 375, rh: 44))
        
        discoverLabel.textColor     = UIColor(hex: "311b92")
        discoverLabel.text          = "Discover"
        discoverLabel.textAlignment = .center
        
        discoverLabel.font = Constants.averageSans
        discoverLabel.font = UIFont.systemFont(ofSize: ((frame.width / 375) * 26))

        
        addSubview(discoverLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    func postButtonPressed() {
        self.delegate?.postButtonPressed()
    }
    
    func nowPlayingButtonPressed() {
        self.delegate?.nowPlayingButtonPressed()
    }
    
    func profileButtonPressed() {
        self.delegate?.profileButtonPressed()
    }
}

protocol FeedViewDelegate {
    func postButtonPressed()
    func nowPlayingButtonPressed()
    func profileButtonPressed()
}
