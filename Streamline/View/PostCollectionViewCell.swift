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
    }
    
    // Setup Functions
    func setupLabels() {
        
    }
    
    func setupAlbumImage() {
        albumImage = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height))
        albumImage.contentMode = .scaleAspectFit
        albumImage.image = UIImage(named: "albumPlaceholder")
        contentView.addSubview(albumImage)
    }
}
