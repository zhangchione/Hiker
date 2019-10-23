//
//  AlbumShowCell.swift
//  VCFactory
//
//  Created by nine on 2018/9/26.
//

import Foundation
import Photos
import UIKit
class AlbumShowCell: UICollectionViewCell {
    var imageView = UIImageView()
    var imageRequestID: PHImageRequestID?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI(with asset: PHAsset) {
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let widght = contentView.frame.width
        let height = (widght / CGFloat(asset.pixelWidth)) * CGFloat(asset.pixelHeight)
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: widght, height: height < contentView.frame.height ? height : contentView.frame.height ))
        imageView.center = contentView.center

    }

    func setUI(with asset: PHAsset) {
        var option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = true
        option.resizeMode = .exact
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFit, options: option) { (thumbnailImage, _) in
            if let image = thumbnailImage {
                self.imageView.image = image
            }
        }
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: option) { (thumbnailImage, _) in
            if let image = thumbnailImage {
                self.imageView.image = image
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        guard let id = imageRequestID else { return }
        PHImageManager.default().cancelImageRequest(id)
    }

}
