//
//  BookViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/15.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class BookViewController: SubClassBaseViewController {
    lazy var tipLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.systemFont(ofSize: 24)
          label.text = "开发者正在努力开发中~ 敬请期待噢"
          label.numberOfLines = 0
          return label
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    

    func configUI() {
        self.navigation.item.title = "故事簿"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
    }

}

