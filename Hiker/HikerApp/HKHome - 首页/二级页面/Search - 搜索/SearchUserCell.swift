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
        
    }
    
    func configShadow() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
    }
}
