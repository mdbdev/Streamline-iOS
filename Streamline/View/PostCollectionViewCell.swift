//
//  PostCollectionViewCell.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    var post: Post!
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
    
    func updateData() {
        songTitleLabel.text = post.songTitle
        artistLabel.text = post.artist
        postUserLabel.text = post.username
        post.getImage { (img) in
            self.albumImage.image = img
        }
    }
    
    // Setup Functions
    func setupView() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        // Drawing the shadow around the cell
        // TODO: investigate runtime of this, as well as shadowPath
        // Shadow is not working correctly :(
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOpacity = 1
//        contentView.layer.shadowOffset = CGSize.zero
//        contentView.layer.shadowRadius = 10
    }
    func setupLabels() {
        songTitleLabel = UILabel(frame: CGRect(x: contentView.frame.height + 10,
                                               y: 16,
                                               width: contentView.frame.width - (contentView.frame.height + 10),
                                               height: 28))
        songTitleLabel.adjustsFontSizeToFitWidth = true
        songTitleLabel.textColor = UIColor.black
        songTitleLabel.text = "Song"
        songTitleLabel.font = Constants.averageSans?.withSize(14)
        contentView.addSubview(songTitleLabel)
        artistLabel = UILabel(frame: CGRect(x: contentView.frame.height + 10,
                                            y: 16 + 14,
                                            width: contentView.frame.width - (contentView.frame.height + 10),
                                            height: 28))
        artistLabel.adjustsFontSizeToFitWidth = true
        artistLabel.textColor = UIColor.black
        artistLabel.text = "Artist"
        artistLabel.font = Constants.averageSans
        contentView.addSubview(artistLabel)
        postUserLabel = UILabel(frame: CGRect(x: contentView.frame.height + 24,
                                              y: 16 + 14 + 20,
                                              width: contentView.frame.width - (contentView.frame.height + 24),
                                              height: 16))
        postUserLabel.textColor = UIColor(hex: "77747a")
        postUserLabel.text = "User"
        postUserLabel.adjustsFontSizeToFitWidth = true
        postUserLabel.font = Constants.averageSans?.withSize(12)
        contentView.addSubview(postUserLabel)
    }
    
    func setupAlbumImage() {
        albumImage = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height))
        albumImage.contentMode = .scaleAspectFit
        albumImage.image = UIImage(named: "albumPlaceholder")
        contentView.addSubview(albumImage)
    }
}
