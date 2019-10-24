//
//  TrackCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/23.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import UIKit

class TrackCell: UICollectionViewCell {
    // 图片
    lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形(2)")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    // 图片
    lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形(2)")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    // 图片
    lazy var imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形(2)")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    // 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "上海"
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var moreBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("更多", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.setImage(UIImage(named: "mine_set_head"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    func setUpUI(){
        self.addSubview(self.imageView1)
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView2)
        self.addSubview(self.imageView3)
        addSubview(moreBtn)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        self.imageView1.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(self).offset(-10)
            make.width.height.equalTo((TKWidth-54)/3)
        }
        self.imageView2.snp.makeConstraints { (make) in
            make.left.equalTo(imageView1.snp.right).offset(12)
            make.bottom.equalTo(self).offset(-10)
            make.width.height.equalTo((TKWidth-54)/3)
        }
        self.imageView3.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-10)
            make.width.height.equalTo((TKWidth-54)/3)
        }
        self.moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
    }
    func configShadow(){
        self.backgroundColor = backColor
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.14).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 19
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
