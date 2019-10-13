//
//  StorySementCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class StorySementCell: UITableViewCell {

    lazy var num: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30)

        label.text = "01"
        return label
    }()
    
    lazy var time: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)

        label.text = "2019-08-30"
        return label
    }()
    
    lazy var location: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 64, g: 102, b: 214)
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "#上海"
        label.textAlignment = .right
        return label
    }()
    
    
    lazy var content: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.text = "下了飞机第一件事是去地铁的人工窗口办一张三日卡，只需要45元，72小时内可以无限制乘坐地铁，能大大节约每次购票的时间和金钱，非常划算，毕竟，上海绝大部分地方，都是可以通过地铁达到的。另外，推荐下载“上海地铁”APP，能够方便查询线路等信息，便于高效换乘。"
        return label
    }()
    
    lazy var photoCell:PhotoCell = {
        let photoCell = PhotoCell()
        return photoCell
    }()
    
    lazy var img: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "矩形备份 2")
        return img
    }()
    
    //分割线
    private var line: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        return vi
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(){
        
    }
    
    func setUpUI(){
        addSubview(num)
        addSubview(time)
        addSubview(location)
        addSubview(content)
        addSubview(img)
        addSubview(photoCell)
        addSubview(line)
        num.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        time.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(num.snp.bottom).offset(1)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        location.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(num.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        content.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(time.snp.bottom).offset(10)
            make.width.equalTo(374)
        }
        photoCell.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(374)
            make.height.equalTo(190)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(1)
            make.bottom.equalTo(self).offset(0)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
