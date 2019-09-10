//
//  MineHeaderView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class MineHeaderView: UIView {

    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home_story_back")
        return iv
    }()
    
    private lazy var userImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "mine_img_user")
        return iv
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        
        label.text = "王依依"
        return label
    }()
    
    lazy var userSign: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.text = "爱旅行、爱p旅拍的小王同学👥"
        return label
    }()
    
    lazy var storyLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .red
        return label
    }()
    lazy var storyBtn: UIButton = {
        let btn = UIButton()
         btn.backgroundColor = .red
        return btn
    }()
    
    lazy var fanLabel: UILabel = {
        let label = UILabel()
                label.backgroundColor = .red
        return label
    }()
    lazy var fanBtn: UIButton = {
        let btn = UIButton()
         btn.backgroundColor = .red
        return btn
    }()
    
    lazy var concernLabel: UILabel = {
        let label = UILabel()
                label.backgroundColor = .red
        return label
    }()
    lazy var concernBtn: UIButton = {
        let btn = UIButton()
                btn.backgroundColor = .red
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI(){
        addSubview(backgroundImageView)
        addSubview(userImg)
        addSubview(userName)
        addSubview(userSign)
        
        addSubview(storyLabel)
        addSubview(storyBtn)
        addSubview(fanLabel)
        addSubview(fanBtn)
        addSubview(concernLabel)
        addSubview(concernBtn)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-44)
            make.height.equalTo(AdaptH(250))
        }
        userImg.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(30))
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(AdaptH(-20))
            make.width.height.equalTo(AdaptW(100))
        }
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(20))
            make.top.equalTo(backgroundImageView.snp.bottom).offset(AdaptH(15))
            make.height.equalTo(AdaptH(25))
            make.width.equalTo(AdaptW(100))
        }
        userSign.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(20))
            make.top.equalTo(userName.snp.bottom).offset(AdaptH(10))
            make.height.equalTo(AdaptH(25))
            make.width.equalTo(AdaptW(200))
        }
        
        storyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        storyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(storyLabel.snp.right).offset(0)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(40)
        }
        fanLabel.snp.makeConstraints { (make) in
            make.left.equalTo(storyBtn.snp.right).offset(30)
            make.bottom.equalTo(self).offset(-20)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        fanBtn.snp.makeConstraints { (make) in
            make.left.equalTo(fanLabel.snp.right).offset(0)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(40)
        }
        concernLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fanBtn.snp.right).offset(30)
            make.bottom.equalTo(self).offset(-20)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        concernBtn.snp.makeConstraints { (make) in
            make.left.equalTo(concernLabel.snp.right).offset(0)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(40)
        }
        
        
    }
    
}
