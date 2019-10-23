//
//  PhotoBottonBanner.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SwifterSwift

struct PhotoBottonBannerActions {
    let deleteCallBack: (() -> Void)
    let shareCallBack: (() -> Void)
    let addCallBack: (() -> Void)
}

class PhotoBottonBanner: UIView {
    let actions: PhotoBottonBannerActions
    var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImageForAllStates(UIImage(named: "photo_button_delete")!)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return btn
    }()
    var shareButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    var addButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColorForAllStates(.black)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleForAllStates("添加至")
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    init(actions: PhotoBottonBannerActions) {
        self.actions = actions
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(deleteButton)
        addSubview(shareButton)
        addSubview(addButton)
        shareButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(18)
            make.height.equalTo(22)
        }
        deleteButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(15)
            make.width.height.equalTo(17)
        }
        addButton.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func deleteAction() {
        actions.deleteCallBack()
    }

    @objc func shareAction() {
        actions.shareCallBack()
    }

    @objc func addAction() {
        actions.addCallBack()
    }
}
