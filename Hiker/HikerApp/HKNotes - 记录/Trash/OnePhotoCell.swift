//
//  OnePhotoCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/12.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class OnePhotoCell: UIView {

    public var imgUrl = ""
    
    // 图片
    private lazy var img: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "矩形")
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
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
        }
        
    }
    
    @objc func add(){
        
    }
    
    var photoDatas:String? {
        didSet{
            guard let photo = photoDatas else {
                return
            }
            self.img.image = UIImage(named: photo)
        }
    }
    
    
}
