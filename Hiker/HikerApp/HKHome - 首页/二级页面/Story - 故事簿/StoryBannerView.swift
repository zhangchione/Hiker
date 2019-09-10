//
//  StoryBannerView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class StoryBannerView: UIView {

    var viewModel: StoryBannerViewModel {
        didSet { updateUI()  }
    }
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home_story_back")
        return iv
    }()
    
    private lazy var nameLabel = UILabel()
    private lazy var titleLabel = UILabel()
//    private lazy var backButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "home_story_back"), for: .normal)
//        button.addTarget(self, action: #selector(backButtonAction), for: .touchDown)
//        return button
//    }()
    private lazy var userButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_story_user"), for: .normal)
        button.addTarget(self, action: #selector(use), for: .touchDown)
        return button
    }()
    init(with viewModel: StoryBannerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configUI()
        updateUI()
    }
    
    @objc func backButtonAction() {
        viewModel.backCallBack?()
    }
    
    @objc func use(){
        viewModel.userCallBack?()
    }
    
    func updateUI(){
        print("更新UI")
        nameLabel.text = "王一一"
        titleLabel.text = "魔都上海两日"
    }
    
    func configUI(){
        addSubview(backgroundImageView)
        addSubview(userButton)
        addSubview(nameLabel)
        addSubview(titleLabel)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        userButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(userButton.snp.centerY)
            make.left.equalTo(userButton.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

        print("加载UI")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
