//
//  StoryView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class StoryView: UICollectionViewCell {
    
    
    lazy var photoCell:PhotoCell = {
       let photoCell = PhotoCell()
        return photoCell
    }()
    
    // 图片
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        return imageView
    }()
    
    // 图片
    lazy var userIcon: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 17.5
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "椭圆形")
        return imageView
    }()
    // 用户名
    lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        label.textColor = UIColor.init(r: 146, g: 146, b: 146)
        label.text = "王一一"
        return label
    }()
    
    // 地点
    lazy var trackLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        label.textColor = UIColor.init(r: 64, g: 102, b: 214)
        label.text = "#上海、广州、深圳"
        label.textAlignment = .right
        return label
    }()
    
    // 标题
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 20)
        label.text = "魔都上海两日"
        label.textAlignment = .left
        return label
    }()
    // 时间
    lazy var time: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        label.textColor = UIColor.init(r: 146, g: 146, b: 146)
        label.text = "2019.8.30"
        label.textAlignment = .right
        return label
    }()
    
    //分割线
    lazy var line: UIView = {
       let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        return vi
    }()
    
    // 被喜欢数量
    lazy var favLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        label.textColor = UIColor.init(r: 214, g: 64, b: 64)
        label.text = "1234"
        
        return label
    }()
    // 被喜欢icon
    lazy var favIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "home_story_loves")
        return img
    }()
    // 收藏按钮
    lazy var favBtn: UIButton = {
        let Btn = UIButton()
        Btn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
        //Btn.addTarget(self, action: #selector(fav), for: .touchUpInside)
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
        addSubview(photoCell)
        
        photoCell.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(AdaptH(190))
            make.top.equalTo(self)
        }
        
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
            make.width.equalTo(AdaptW(100))
            make.height.equalTo(AdaptH(20))
        }
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(15))
            make.centerY.equalTo(time.snp.centerY)
            make.width.equalTo(AdaptW(180))
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
            make.width.equalTo(AdaptW(100))
            make.height.equalTo(AdaptH(20))
        }
        
        trackLocation.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(AdaptW(-15))
            make.centerY.equalTo(userIcon.snp.centerY)
            make.width.equalTo(AdaptW(200))
            make.height.equalTo(AdaptH(20))
        }
    
    }
    
    
    func configShadow(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    var liked = false {
        willSet{
            guard newValue != liked else { return }
            update(isliked:newValue)
            
        }
    }
    var collected = false {
        willSet{
            guard newValue != collected else { return }
            //updateCollected(iscollected:newValue)
        }
    }
    
    func update(isliked:Bool) {
        guard isliked else {
            self.favIcon.image = UIImage(named: "home_story_loves")
            return
        }
         self.favIcon.image = UIImage(named: "home_stroy_unlove")
    }
    
//    func updateCollected(iscollected:Bool) {
//        guard iscollected else {
//            self.favB
//            self.favIcon.image = UIImage(named: "home_story_love")
//            return
//        }
//        self.favIcon.image = UIImage(named: "home_stroy_unlove")
//    }
    
    @objc func fav(){
        favBtn.setImage(UIImage(named: "home_story_fav"), for: .normal)
        self.favLabel.text = "\(Int(favLabel.text!)! + 1)"
    }
}
