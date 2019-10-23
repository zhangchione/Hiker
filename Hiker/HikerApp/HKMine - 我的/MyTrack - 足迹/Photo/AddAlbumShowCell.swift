//
//  AddAlbumShowCell.swift
//  VCFactory
//
//  Created by nine on 2018/12/29.
//

import Foundation
import SnapKit
class AddAlbumShowCell: UICollectionViewCell {
    var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        imageView.image = UIImage.init(named: "show_album_new")
    }

}
