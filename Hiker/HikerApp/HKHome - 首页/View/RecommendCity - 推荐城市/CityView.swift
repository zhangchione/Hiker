//
//  CityView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class CityView: UICollectionViewCell {
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形(2)")
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "上海"
        label.textColor = UIColor.white
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    func setUpUI(){
        self.addSubview(self.imageView)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
            make.width.equalTo(140)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    func configShadow(){
        self.backgroundColor = backColor
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 19
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
