//
//  PhotoBannerView.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SwifterSwift

class PhotoBannerView: UIView {
    var viewModel: PhotoBannerViewModel {
        didSet { updateUI() }
    }
     lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        let cover = UIImageView()
        cover.backgroundColor = UIColor(white: 0, alpha: 0.2)
        iv.addSubview(cover)
        cover.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return iv
    }()
    lazy var saveButton: UIButton = {
        let button = UIButton()
//        button.setImageForAllStates(UIImage(named: "Ar2")!)
//        button.centerTextAndImage(spacing: 6)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
     lazy var nameLabel : UILabel = {
       let l = UILabel()
        l.font = UIFont(name: "PingFangSC-Semibold", size: 24)
        l.textColor = UIColor.white
        return l
    }()
    private lazy var describeLabel : UILabel =  {
        let l = UILabel()
        l.font = UIFont(name: "PingFangSC-Medium", size: 16)
        l.textColor = UIColor.white
        return l
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton()
       
        button.setTitle("←", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchDown)
        return button
    }()
    private lazy var removeButton: UIButton = {
        let button = UIButton()
      
        button.isHidden = true
        return button
    }()
    init(with viewModel: PhotoBannerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configUI()
        updateUI()
    }

    func updateUI() {
        backgroundImageView.image = viewModel.image
        // nameLabel
//        nameLabel.text = "06.01 - 07.12"
        let nameAttrString = NSMutableAttributedString(string: viewModel.album.name)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.28)
        shadow.shadowBlurRadius = 2
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 21, weight: .bold), .foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), .shadow: shadow]
        nameAttrString.addAttributes(attr, range: NSRange(location: 0, length: nameAttrString.length))
        nameLabel.attributedText = nameAttrString
        // nameLabel

        // describeLabel
        let describeAttrString = NSMutableAttributedString(string: viewModel.bannerDescribeText())
        describeLabel.numberOfLines = 0
        let describeAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        describeAttrString.addAttributes(describeAttr, range: NSRange(location: 0, length: describeAttrString.length))
        describeLabel.attributedText = describeAttrString
        // describeLabel
        let cityName = viewModel.album.name
        let citeKey = cityName.substring(to: 2) + "之回忆"
        nameLabel.text = citeKey
        removeButton.isHidden = (viewModel.album.type != .custom)
    }

    @objc func backButtonAction() {
        viewModel.backCallBack?()
    }

    @objc func removeButtonAction() {
        viewModel.removeCallBack?()
    }



    private func configUI() {
        addSubview(backgroundImageView)
        addSubview(saveButton)
        addSubview(nameLabel)
        addSubview(describeLabel)
        //addSubview(backButton)
        addSubview(removeButton)
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        backgroundImageView.addSubview(blurView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        describeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(describeLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(saveButton.snp.top)
            make.left.equalTo(describeLabel)
            make.right.equalTo(saveButton.snp.left).offset(-20)
            make.height.equalTo(20)
        }
//        backButton.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().inset(20)
//            make.top.equalToSuperview().inset(14+UIScreen().titleY)
//            make.width.height.equalTo(32)
//        }
        removeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(14+UIScreen().titleY)
            make.width.height.equalTo(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
