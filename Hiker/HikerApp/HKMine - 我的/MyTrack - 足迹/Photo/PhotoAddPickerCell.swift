//
//  PhotoAddPickerCell.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SwifterSwift
import Photos

class PhotoAddPickerCell: UIView {
    var album: Album? {
        didSet {
            guard let album = album else { return }
            updateUI(with: album)
        }
    }
    func updateUI(with album: Album) {
        removeSubviews()
        backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        // photo
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        if album.photos.count != 0 {
            for i in 0..<min(4,album.photos.count) {
                var currentX = 0
                var currentY = 0
                switch i {
                case 0: currentX = 0;currentY = 0
                case 1: currentX = 34;currentY = 0
                case 2: currentX = 0;currentY = 34
                case 3: currentX = 34;currentY = 34
                default:
                    break
                }
                let imageView = UIImageView()
                imageView.frame = CGRect(x: currentX, y: currentY, width: 33, height: 33)
                manager.requestImage(for: album.photos[i].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill, options: option) { (thumbnailImage, _) in
                    imageView.image = thumbnailImage
                }
                addSubview(imageView)
            }
        }
        // name
        let nameLabel = UILabel()
        nameLabel.frame = CGRect.init(x: 99, y: 11, width: 200, height: 25)
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = Color(hexString: "#3A3F3E")
        nameLabel.text = album.name
        addSubview(nameLabel)
        // count
        let countLabel = UILabel()
        countLabel.frame = CGRect(x: 99, y: 40, width: 200, height: 15)
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textColor = Color(hexString: "#C1C8C8")
        countLabel.text = "\(album.photos.count)"
        addSubview(countLabel)
    }
}
