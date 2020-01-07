//
//  UserHeaderView.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/15.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import UIKit

class UserHeaderView: UIView {

    lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "home_story_back")
        return iv
    }()
    
     lazy var userImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "mine_img_user")
        iv.layer.cornerRadius = 50
        return iv
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        label.text = "王一一"
        return label
    }()
    
    lazy var userSign: UILabel = {
        let label = UILabel()
        label.textColor = .black
              label.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        label.text = "爱旅行，爱旅拍的小王同学🙋‍♂️"
        return label
    }()
    
    lazy var alterBtn: UIButton = {
       let btn = UIButton()
        btn.setTitle("已经关注", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
        lazy var storyLabel: UILabel = {
       let label = UILabel()
       // label.backgroundColor = .red
        label.text = "17"
        label.font = BoldFontSize(20)//UIFont.init(name: "PingFangSC-Semibold", size: 20)
        return label
    }()
    lazy var storyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("游记", for: .normal)
        btn.titleLabel?.font = FontSize(15)//UIFont.init(name: "PingFangSC-Regular", size: 15)
        btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        return btn
    }()
    
    lazy var fanLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = BoldFontSize(20)//UIFont.init(name: "PingFangSC-Semibold", size: 20)
        return label
    }()
    lazy var fanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("粉丝", for: .normal)
        btn.titleLabel?.font = FontSize(15)//UIFont.init(name: "PingFangSC-Regular", size: 15)
        btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        return btn
    }()
    
    lazy var concernLabel: UILabel = {
        let label = UILabel()
        label.text = "17"
        label.font = BoldFontSize(20)//UIFont.init(name: "PingFangSC-Semibold", size: 20)
        return label
    }()
    lazy var concernBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关注", for: .normal)
                btn.titleLabel?.font = FontSize(15)//UIFont.init(name: "PingFangSC-Regular", size: 15)
                btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(){
        
    }
    
    func configUI(){
        addSubview(backgroundImageView)
        addSubview(userImg)
        addSubview(userName)
        addSubview(userSign)
        addSubview(alterBtn)
        
        addSubview(storyLabel)
        addSubview(storyBtn)
        addSubview(fanLabel)
        addSubview(fanBtn)
        addSubview(concernLabel)
        addSubview(concernBtn)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(AdaptH(-44))
            make.height.equalTo(AdaptH(225))
        }
        userImg.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(22))
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(AdaptH(-16))
            make.width.height.equalTo(AdaptW(100))
        }
        
        alterBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-AdaptW(60))
            make.centerY.equalTo(userImg.snp.centerY)
            make.height.equalTo(AdaptH(40))
            make.width.equalTo(AdaptW(120))
        }
        
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(16))
            make.top.equalTo(backgroundImageView.snp.bottom).offset(AdaptH(8))
            make.height.equalTo(AdaptH(22))
            make.width.equalTo(AdaptW(200))
        }
        userSign.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(AdaptW(16))
            make.top.equalTo(userName.snp.bottom).offset(AdaptH(6))
            make.height.equalTo(AdaptH(25))
            make.width.equalTo(AdaptW(300))
        }

        
        
        storyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(userSign.snp.bottom).offset(Adapt(28))
            make.height.equalTo(AdaptH(20))
            if TKWidth >= 812 {
                make.width.equalTo(AdaptW(30))
            }else {
                make.width.equalTo(35)
            }

        }
        storyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(storyLabel.snp.right).offset(0)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(AdaptH(25))
            make.width.equalTo(AdaptW(35))
        }
        fanLabel.snp.makeConstraints { (make) in
            make.left.equalTo(storyBtn.snp.right).offset(30)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(AdaptH(20))
            if TKWidth >= 812 {
                make.width.equalTo(AdaptW(20))
            }else {
                make.width.equalTo(35)
            }
        }
        fanBtn.snp.makeConstraints { (make) in
            make.left.equalTo(fanLabel.snp.right).offset(0)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(AdaptH(25))
            make.width.equalTo(AdaptW(35))
        }
        concernLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fanBtn.snp.right).offset(30)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(AdaptH(20))
            if TKWidth >= 812 {
                make.width.equalTo(AdaptW(20))
            }else {
                make.width.equalTo(35)
            }
        }
        concernBtn.snp.makeConstraints { (make) in
            make.left.equalTo(concernLabel.snp.right).offset(0)
            make.centerY.equalTo(storyLabel.snp.centerY)
            make.height.equalTo(AdaptH(25))
            make.width.equalTo(AdaptW(35))
        }
        
        
    }
    
}
