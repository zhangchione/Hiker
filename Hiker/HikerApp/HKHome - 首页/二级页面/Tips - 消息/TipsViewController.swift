//
//  TipsViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class TipsViewController: SubClassBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       configUI()
    }
    
    func configUI(){
        self.navigation.item.title = "消息"
    }


}
