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
        
        setupLabels()
        setupAlbumImage()
    }
    
    func updateData() {
        songTitleLabel.text = post.songTitle
        artistLabel.text = post.artist
        postUserLabel.text = post.uid
        // update image
    }
    
    // Setup Functions
    func setupLabels() {
        songTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(songTitleLabel)
        artistLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(artistLabel)
        postUserLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(postUserLabel)
    }
    
    func setupAlbumImage() {
        albumImage = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height))
        albumImage.contentMode = .scaleAspectFit
        albumImage.image = UIImage(named: "albumPlaceholder")
        contentView.addSubview(albumImage)
    }
}
