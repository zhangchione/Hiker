//
//  StoryView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class StoryView: UICollectionViewCell {
    
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 图片
    private var userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.image = UIImage(named: "椭圆形")
        return imageView
    }()
    // 用户名
    private var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "王一一"
        return label
    }()
    
    // 地点
    private var trackLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "#上海、广州、深圳"
        return label
    }()
    
    // 标题
    private var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "魔都上海两日"
        return label
    }()
    // 时间
    private var time: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "2019.8.30"
        return label
    }()
    
    //分割线
    private var line: UIView = {
       let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        return vi
    }()
    
    // 被喜欢数量
    private var favLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "1234"
        
        return label
    }()
    // 被喜欢icon
    private var favIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "home_story_love")
        return img
    }()
    // 收藏按钮
    private var favBtn: UIButton = {
        let Btn = UIButton()
        Btn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
        return Btn
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
        
        addSubview(favBtn)
        addSubview(favIcon)
        addSubview(favLabel)
        addSubview(line)
        addSubview(time)
        addSubview(title)
        addSubview(trackLocation)
        addSubview(userIcon)
        addSubview(userName)
        
        favBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(AdaptW(-15))
            make.bottom.equalTo(self).offset(AdaptH(-20))
            make.width.equalTo(AdaptW(15))
            make.height.equalTo(AdaptH(20))
        }
        favIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(15))
            make.bottom.equalTo(self).offset(AdaptH(-20))
            make.width.equalTo(AdaptW(25))
            make.height.equalTo(AdaptH(20))
        }
        favLabel.snp.makeConstraints { (make) in
            make.left.equalTo(favIcon.snp.right).offset(AdaptW(5))
            make.centerY.equalTo(favIcon.snp.centerY)
            make.width.equalTo(AdaptW(50))
            make.height.equalTo(AdaptH(20))
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(15))
            make.bottom.equalTo(favBtn.snp.top).offset(AdaptH(-20))
            make.right.equalTo(self).offset(AdaptW(-15))
            make.height.equalTo(AdaptH(0.8))
        }
        time.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(AdaptW(-15))
            make.bottom.equalTo(line.snp.top).offset(AdaptH(-20))
            make.width.equalTo(AdaptW(60))
            make.height.equalTo(AdaptH(20))
        }
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(15))
            make.centerY.equalTo(time.snp.centerY)
            make.width.equalTo(AdaptW(100))
            make.height.equalTo(AdaptH(30))
        }
        userIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(15))
             make.bottom.equalTo(title.snp.top).offset(AdaptH(-10))
            make.width.equalTo(AdaptW(35))
            make.height.equalTo(AdaptH(35))
        }
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp.right).offset(AdaptW(5))
            make.centerY.equalTo(userIcon.snp.centerY)
            make.width.equalTo(AdaptW(60))
            make.height.equalTo(AdaptH(20))
        }
        
        trackLocation.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(AdaptW(-15))
            make.centerY.equalTo(userIcon.snp.centerY)
            make.width.equalTo(AdaptW(120))
            make.height.equalTo(AdaptH(20))
        }
        
        
        
    }
    func configShadow(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
}
