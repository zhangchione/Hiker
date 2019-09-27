//
//  FivePhotoCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/16.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class FivePhotoCell: UIView {

    
    // 图片1
    lazy var img1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形")
        return imageView
    }()
    // 图片2
    lazy var img2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形")
        return imageView
    }()
    // 图片3
    lazy var img3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形")
        return imageView
    }()
    // 图片4
    lazy var img4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形")
        return imageView
    }()
    // 图片5
    lazy var img5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "矩形")
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
    }

}
