//
//  CommentCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/14.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    lazy var userIcon:UIImageView = {
       let img = UIImageView()
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        img.image = UIImage(named: "椭圆形(1)")
        return img
    }()
    
    // 用户名
    lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "李一一"
        label.textColor = UIColor.black
        return label
    }()
    // 时间
    lazy var time: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "09-01"
        label.textColor = UIColor.black
        return label
    }()
    
    // 数量
    lazy var content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "好好看，我也想去看呀"
        label.textColor = UIColor.black
        label.textAlignment = .left
        //label.backgroundColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    lazy var favBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setImage(UIImage(named: "home_icon_zan"), for: .normal)
        btn.setTitle("7", for: .normal)
        btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(with data:Comments) {
        
        let imgUrl = URL(string: data.user!.headPic)
        self.userIcon.kf.setImage(with: imgUrl)
        self.username.text = data.user?.nickName
        self.time.text = data.time.substring(to: 10)
        self.content.text = data.content
        content.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    func setUpUI(){
        
        addSubview(userIcon)
        addSubview(username)
        addSubview(time)
        addSubview(content)
        addSubview(favBtn)
        userIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        username.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(70)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
        time.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(70)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(70)
            make.right.equalTo(self).offset(-70)
        }
        favBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
    }

}
