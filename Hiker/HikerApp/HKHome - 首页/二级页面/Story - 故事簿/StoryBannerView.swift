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
    
    private lazy var nameLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "苹方-简 常规体", size: 14)
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
         label.font = UIFont.init(name: "苹方-简 中粗体", size: 30)
         return label
    }()
    private lazy var userImg = UIImage()
    private lazy var favButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "home_stroy_favwhite"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchDown)
        return button
    }()
//    private lazy var userButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "椭圆形"), for: .normal)
//        button.addTarget(self, action: #selector(use), for: .touchDown)
//        DispatchQueue.main.async {
//        button.corner(byRoundingCorners: [.bottomLeft,.bottomRight,.topLeft,.topRight], radii: 20)
//        }
//        return button
//    }()
    private lazy var userButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home_story_back")
        iv.layer.cornerRadius = 20
        return iv
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
        nameLabel.text = viewModel.model?.user?.username
        titleLabel.text = viewModel.model?.title
//        userButton.setImage(UIImage(named: (viewModel.model?.user!.headPic)!), for: .normal)
        
        let imgUrl = URL(string: (viewModel.model?.user!.headPic)!)
        
        self.userButton.kf.setImage(with: imgUrl)

        let pics = viewModel.model?.noteParas![0].pics.components(separatedBy: ",")
        
        let imgUrl2 = URL(string: pics![0])
        self.backgroundImageView.kf.setImage(with: imgUrl2)
        
    }
    
    func configUI(){
        addSubview(backgroundImageView)
        addSubview(userButton)
        addSubview(nameLabel)
        addSubview(titleLabel)
        addSubview(favButton)
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
        
        favButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(16)
            make.height.equalTo(20)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
