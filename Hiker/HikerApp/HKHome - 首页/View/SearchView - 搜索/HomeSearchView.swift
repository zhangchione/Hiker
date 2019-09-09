//
//  HomeSearchView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class HomeSearchView: UICollectionViewCell {
    
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(r: 204, g: 204, b: 204)
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        configShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI(){
        self.addSubview(self.imageView)
        self.imageView.image = UIImage(named: "home_icon_ser")
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self).offset(10)
            make.height.width.equalTo(20)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "找到你想了解的故事"
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(20)
        }
    }
    func configShadow(){
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 0.12).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 19
        self.layer.cornerRadius = 10
    }
}
