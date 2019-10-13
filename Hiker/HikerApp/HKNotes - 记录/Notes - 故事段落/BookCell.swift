//
//  BookCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit

class BookCell: UITableViewCell {

    // 标题
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "地点"
        label.textColor = UIColor.black
        return label
    }()
    // 数量
    lazy var num: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "3篇"
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
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

    func updateUI(with data:BookModel) {
        self.name.text = data.name
        self.num.text = "\(data.num)篇"
    }
    
    func setUpUI(){
        
        addSubview(name)
        addSubview(num)
        name.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(0)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        num.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-45)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}
