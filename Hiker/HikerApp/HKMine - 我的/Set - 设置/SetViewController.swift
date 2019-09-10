//
//  SetViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }


    func configUI(){
        self.navigation.item.title = "设置"
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = true
            self.navigation.item.largeTitleDisplayMode = .automatic
        }
    }

}
