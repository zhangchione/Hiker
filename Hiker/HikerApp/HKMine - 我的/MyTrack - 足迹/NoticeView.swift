//
//  NoticeView.swift
//  VCFactory
//
//  Created by nine on 2018/10/4.
//

import Foundation
import UIKit

class NoticeView: UIView {
    var progressLabel = UILabel()
    var noticeLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    func configUI() {
        addSubview(progressLabel)
        addSubview(noticeLabel)
        progressLabel.textAlignment = .center
        noticeLabel.textAlignment = .center
        progressLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(progressLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        progressLabel.font = UIFont.init(name: "Apercu-Bold", size: 23)
        noticeLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        noticeLabel.textColor = UIColor.black
        progressLabel.text = "0/0"
        noticeLabel.text =  "分类中"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
