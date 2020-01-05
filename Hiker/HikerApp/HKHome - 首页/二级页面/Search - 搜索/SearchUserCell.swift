//
//  SearchUserCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/12.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import UIKit

class SearchUserCell: UIView {
    
    // 图片
    lazy var userIcon: UIImageView = {
            let imageView = UIImageView()
    //        imageView.backgroundColor = .red
            imageView.layer.cornerRadius = AdaptH(30)
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "椭圆形")
            return imageView
        }()
    
    lazy var nickName: UILabel = {
       let label = UILabel()
        label.font = FontSize(16)// UIFont.init(name: "苹方-简 常规体", size: )
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
        label.textAlignment = .center
        return label
    }()
    
    lazy var detial: UILabel = {
       let label = UILabel()
        label.font = FontSize(12) //UIFont.init(name: "苹方-简 常规体", size: )
        label.textColor = UIColor.init(r: 146, g: 146, b: 146)
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        configUI()
        configShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(with data:User){
        
        let imgUrl = URL(string: data.headPic)
        self.userIcon.kf.setImage(with: imgUrl)
        self.nickName.text = data.nickName
        self.detial.text = "\(data.notes)故事 | \(data.fans)粉丝"
    }
    
    func configUI() {
        addSubview(userIcon)
        addSubview(nickName)
        addSubview(detial)
        userIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(AdaptH(10))
            make.centerX.equalTo(self)
            make.height.width.equalTo(AdaptH(60))
        }
        nickName.snp.makeConstraints { (make) in
            make.top.equalTo(userIcon.snp.bottom).offset(AdaptH(15))
            make.centerX.equalTo(self)
            make.height.equalTo(AdaptH(20))
            make.width.equalTo(self)
        }
        detial.snp.makeConstraints { (make) in
            make.top.equalTo(nickName.snp.bottom).offset(AdaptH(15))
            make.centerX.equalTo(self)
            make.height.equalTo(AdaptH(15))
            make.width.equalTo(self)
        }
    }
    
    func configShadow() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
    }
}
