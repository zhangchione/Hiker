//
//  TipsViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class TipsViewController: SubClassBaseViewController {

    // 图片1
    lazy var img1: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100 ))
        imageView.image = UIImage(named: "home_story_back")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configUI()
    }
    
    func configUI(){
        self.navigation.item.title = "消息"
        let maskPath = UIBezierPath(roundedRect: img1.bounds, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        // 设置大小
        maskLayer.frame = img1.bounds
        // 设置图形样子
        maskLayer.path = maskPath.cgPath
        img1.layer.mask = maskLayer
        view.addSubview(img1)
    }


}
