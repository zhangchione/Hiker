//
//  HeaderView.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/23.
//  Copyright © 2019 张驰. All rights reserved.
//


import UIKit

class TrackHeaderReusableView: UICollectionReusableView {
    // 标题
     var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        label.textColor = UIColor.init(r: 56, g: 56, b: 56 )
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        self.backgroundColor = backColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "推荐城市"
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(20)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }
}
