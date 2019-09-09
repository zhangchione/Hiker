//
//  StoryView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class StoryView: UICollectionViewCell {
    
    // 图片
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 图片
    private var userIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // 标题
    private var trackLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // 标题
    private var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    // 标题
    private var time: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    // 标题
    private var favLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    // 标题
    private var favIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    // 标题
    private var favBtn: UIButton = {
        let Btn = UIButton()
        Btn.backgroundColor = .red
        return Btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        configShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        
        
        
    }
    func configShadow(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 6
    }
}
