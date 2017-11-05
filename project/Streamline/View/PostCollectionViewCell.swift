//
//  PostCollectionViewCell.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    //var post: Post!
    var songTitleLabel: UILabel!
    var artistLabel: UILabel!
    var postUserLabel: UILabel!
    var albumImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupLabels()
        setupAlbumImage()
    }
    
    // Setup Functions
    func setupView() {
        self.backgroundColor = UIColor.white
    }
    func setupLabels() {
        songTitleLabel = UILabel(frame: CGRect(x: contentView.frame.height + 10,
                                               y: 6,
                                               width: contentView.frame.width - (contentView.frame.height + 10),
                                               height: 28))
        songTitleLabel.adjustsFontSizeToFitWidth = true
        songTitleLabel.textColor = UIColor.black
        songTitleLabel.text = "Song"
        songTitleLabel.font = Constants.averageSans?.withSize(20)
        songTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: 2)
        contentView.addSubview(songTitleLabel)
        
        
        artistLabel = UILabel(frame: CGRect(x: contentView.frame.height + 10,
                                            y: 16 + 7,
                                            width: contentView.frame.width - (contentView.frame.height + 10),
                                            height: 28))
        artistLabel.adjustsFontSizeToFitWidth = true
        artistLabel.textColor = UIColor.black
        artistLabel.text = "Artist"
        artistLabel.font = Constants.averageSans
        artistLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(artistLabel)
        
        postUserLabel = UILabel(frame: CGRect(x: contentView.frame.height + 10,
                                              y: 16 + 7 + 20,
                                              width: contentView.frame.width - (contentView.frame.height + 24),
                                              height: 16))
        postUserLabel.textColor = UIColor(hex: "77747a")
        postUserLabel.text = "User"
        postUserLabel.adjustsFontSizeToFitWidth = true
        postUserLabel.font = Constants.averageSans?.withSize(12)
        postUserLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(postUserLabel)
    }
    
    func setupAlbumImage() {
        albumImage = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height))
        albumImage.contentMode = .scaleAspectFit
        albumImage.image = UIImage(named: "albumPlaceholder")
        contentView.addSubview(albumImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postUserLabel.isHidden = true
        artistLabel.isHidden = true
        songTitleLabel.isHidden = true
        albumImage.isHidden = true
    }
}
