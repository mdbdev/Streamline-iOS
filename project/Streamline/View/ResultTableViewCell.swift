//
//  ResultTableViewCell.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/26/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import UIKit
class ResultTableViewCell: UITableViewCell {
    var songTitle: UILabel!
    var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabels()
    }
    
    func setupLabels() {
        let musicIcon: UIImageView = UIImageView(frame: Utils.sRect(sqx: 13, sqy: 10, sqw: 9, sqh: 10))
        musicIcon.image = #imageLiteral(resourceName: "music note")
        contentView.addSubview(musicIcon)
        
        songTitle = UILabel(frame: Utils.rRect(rx: 30.05, ry: 6, rw: 188.19, rh: 17.27))
        songTitle.text = ""
        songTitle.textColor = UIColor.black
        contentView.addSubview(songTitle)
        
        artist = UILabel(frame: CGRect(x: 0, y: contentView.frame.height / 2, width: contentView.frame.width, height: contentView.frame.height / 2))
        artist.text = ""
        artist.textColor = UIColor.black
        contentView.addSubview(artist)
    }
    
    override func prepareForReuse() {
        songTitle.isHidden = true
        artist.isHidden = true
    }
}
