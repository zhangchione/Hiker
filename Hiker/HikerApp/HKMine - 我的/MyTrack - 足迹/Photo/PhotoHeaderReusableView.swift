//
//  PhotoHeaderReusableView.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SnapKit
import SwifterSwift
class PhotoHeaderReusableView: UICollectionReusableView {
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Medium", size: 20)
        label.textAlignment = .left
        label.textColor = Color.init(hexString: "#000000")
        return label
    }()
    var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        label.textAlignment = .right
        label.textColor = Color.init(hexString: "#202020")
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {
        addSubview(dateLabel)
        addSubview(yearLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(10)
            make.left.equalTo(self).inset(20)
            make.width.equalTo(55)
        }
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(dateLabel)
           // make.top.equalTo(self).inset(10)
            make.left.equalTo(dateLabel.snp.right).inset(0)
            make.width.equalTo(45)
        }
    }
}
