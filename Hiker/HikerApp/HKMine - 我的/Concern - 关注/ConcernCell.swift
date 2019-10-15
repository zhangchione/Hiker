//
//  ConcernCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/14.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class ConcernCell: UITableViewCell {

   lazy var userIcon:UIImageView = {
       let img = UIImageView()
        img.layer.cornerRadius = 30
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
    lazy var sgin: UILabel = {
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
    
    lazy var concrenBtn: UIButton = {
       let btn = UIButton()
       
       btn.setTitle("已经关注", for: .normal)
       btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
       btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
       btn.layer.cornerRadius = 5
       return btn
    }()
    
    lazy var line: UIView = {
       let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        return vi
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

    func updateUI(with data:User) {
        self.backgroundColor = backColor
        let imgUrl = URL(string: data.headPic)
        self.userIcon.kf.setImage(with: imgUrl)
        self.username.text = data.nickName
        self.sgin.text = data.sgin
    }
    
    func setUpUI(){
        
        addSubview(userIcon)
        addSubview(username)
        addSubview(sgin)
        addSubview(concrenBtn)
        addSubview(line)
        userIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        username.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-12)
            make.left.equalTo(self).offset(90)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        sgin.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(12)
            make.left.equalTo(self).offset(90)
            make.height.equalTo(25)
            make.width.equalTo(200)
        }
        concrenBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(100)
            make.bottom.equalTo(self).offset(-20)
        }
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
            make.right.equalTo(self)
            make.left.equalTo(self).offset(20)
        }
        
    }
}
