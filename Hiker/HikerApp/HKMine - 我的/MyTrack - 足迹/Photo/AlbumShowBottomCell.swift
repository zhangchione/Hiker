//
//  AlbumShowclassifyCell.swift
//  VCFactory
//
//  Created by nine on 2018/9/28.
//

import UIKit
import SnapKit

class AlbumShowBottomCell: UICollectionViewCell {
    let backView = UIView()
    let imageView = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    func configUI() {
        let ivHeight = 64.0.fit
        let space = 1.0.fit
        contentView.addSubview(backView)
        backView.addSubview(imageView)
        backView.addSubview(imageView2)
        backView.addSubview(imageView3)
        backView.addSubview(label)
        backView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(99.fit-4)
        }
        imageView.frame = CGRect(x: 0, y: 0, width: ivHeight, height: ivHeight)
        imageView2.frame = CGRect(x: ivHeight + space, y: 0, width: ivHeight/2  - space/2, height: ivHeight/2  - space/2)
        imageView3.frame = CGRect(x: ivHeight + space, y: ivHeight/2 + space/2, width: ivHeight/2 - space/2, height: ivHeight/2 - space/2)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(34.fit)
            make.bottom.left.right.equalToSuperview()
        }
        label.textAlignment = .center
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView2.contentMode = .scaleAspectFill
        imageView2.clipsToBounds = true
        imageView3.contentMode = .scaleAspectFill
        imageView3.clipsToBounds = true
        backView.clipsToBounds = true
        label.font = UIFont(name: "PingFangSC-Light", size: 12)
        label.textColor = UIColor(rgb: 0x3A3F3E)
        backgroundColor = UIColor(rgb: 0xCCD3D3)
        backView.backgroundColor = UIColor(rgb: 0xF6F6F6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
