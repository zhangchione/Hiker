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
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
         label.font = UIFont.init(name: "PingFangSC-Semibold", size: 30)
         return label
    }()
    
    private lazy var userImg = UIImage()
    private lazy var favButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "home_stroy_favwhite"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchDown)
        return button
    }()
    private lazy var userButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "椭圆形"), for: .normal)
        button.addTarget(self, action: #selector(use), for: .touchDown)
   //     DispatchQueue.main.async {
//        button.corner(byRoundingCorners: [.bottomLeft,.bottomRight,.topLeft,.topRight], radii: 20)
//        }
        return button
    }()
    private lazy var userIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home_story_back")
        iv.layer.cornerRadius = 25
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
        nameLabel.text = viewModel.model?.user?.nickName
        titleLabel.text = viewModel.model?.title
//        userButton.setImage(UIImage(named: (viewModel.model?.user!.headPic)!), for: .normal)
        
        let imgUrl = URL(string: (viewModel.model?.user!.headPic)!)
        
        self.userIcon.kf.setImage(with: imgUrl)

        let pics = viewModel.model?.noteParas![0].pics.components(separatedBy: ",")
        
        let imgUrl2 = URL(string: pics![0])
        self.backgroundImageView.kf.setImage(with: imgUrl2)
        
        var locations = [String]()
        for note in (viewModel.model?.noteParas!)! {
            locations.append(note.place)
        }
        let se = Set(locations)
        locations = Array(se)
        let place = locations.joined(separator: "-")
        
        locationsLabel.text =  place
    }
    lazy var locationsLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        label.backgroundColor = UIColor.init(r: 46, g: 46, b: 46,alpha: 0.5)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    func configUI(){
        addSubview(backgroundImageView)
        addSubview(userIcon)
        addSubview(nameLabel)
        addSubview(titleLabel)
        addSubview(favButton)
        addSubview(userButton)
        addSubview(locationsLabel)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(25)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(TKWidth/2)
            make.height.equalTo(30)
        }
        locationsLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(130)
            make.height.equalTo(30)
        }
        userIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        userButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(userIcon.snp.centerY)
            make.left.equalTo(userIcon.snp.right).offset(10)
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
