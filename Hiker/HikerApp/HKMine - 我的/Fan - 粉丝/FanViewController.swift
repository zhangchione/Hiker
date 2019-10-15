//
//  FanViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/18.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class FanViewController: SubClassBaseViewController {
    var data = [User]()
    
    convenience init(data:[User]) {
        self.init()
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    

    func configUI(){
        self.view.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        self.navigation.item.title = "粉丝"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
    }

}
