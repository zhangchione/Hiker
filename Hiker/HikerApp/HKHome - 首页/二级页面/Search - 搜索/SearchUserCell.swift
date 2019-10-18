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
    
    lazy var zanwu: UILabel = {
       let label = UILabel()
        label.text = "暂无推荐噢~"
        label.font = UIFont.init(name: "苹方-简 中黑体", size: 14)
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
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
    
    func updateUI(with data:SearchUserModel){
        
    }
    
    func configUI() {
        addSubview(zanwu)
        zanwu.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    func configShadow() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
    }
}
