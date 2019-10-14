//
//  AlterSign.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/14.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD

protocol AlterSginDelegate : class {
    func passBookName(with bookName: String)
}

class AlterSginView: UIView {

    weak var delegate : AlterSginDelegate?
    
    private lazy var bgView = UIView()
    private lazy var titleLab = UILabel()
    private lazy var line1 = UIView()
    private lazy var closeBtn = UIButton()
    private lazy var startTrackBtn = UIButton()
    
    lazy var textField : UITextField = {
       let tf = UITextField()
        tf.placeholder = "修改您喜欢的签名吧~"
        tf.delegate = self
        return tf
    }()
    
    var dismissKetboardTap = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.becomeFirstResponder()
        
        self.backgroundColor = UIColor.init(r: 33, g: 33, b: 33,alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenAddView))
        //self.addGestureRecognizer(tap)
        self.isHidden = true
        configUI()
        // 配置所有子视图
        // 关闭键盘
//        dismissKetboardTap = UITapGestureRecognizer(target: bgView, action: #selector(self.dismissKeyboard))
//        bgView.addGestureRecognizer(dismissKetboardTap)
        
        TKinitWithAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TKinitWithAllView() {
        
    }
    // 隐藏窗口
    @objc func  hiddenAddView(){
        self.endEditing(false)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
            self.bgView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (isSuccess) in
            
            self.isHidden = true
        }
    }
    // 显示窗口
    func showAddView() {
        self.alpha = 0.0
        self.isHidden = false
        self.bgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.bgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (isSuccess) in
        }
    }
    
    func configUI(){
        self.bgView  = UIView.tk_createView(bgClor: UIColor.white
                , supView: self, closure: { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(self.snp.centerY).offset(Adapt(-100))
                make.width.equalTo(TKWidth - Adapt(40))
                make.height.equalTo(TKHeight - Adapt(500))
        })
        self.bgView.layer.cornerRadius = 15
        
        self.titleLab = UILabel.tk_createLabel(text: "修改签名", textColor:  kBlack, font: BoldFontSize(24), supView: self.bgView, closure: { (make) in
            //make.left.equalTo(Adapt(30))
            make.top.equalTo(Adapt(50))
            make.centerX.equalTo(self.bgView.snp.centerX)
            make.height.equalTo(Adapt(32))
        })
        
        self.bgView.addSubview(textField)
        self.textField.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLab.snp.centerX)
            make.height.equalTo(Adapt(40))
            make.width.equalTo(Adapt(250))
            make.top.equalTo(titleLab.snp.bottom).offset(30)
        }
        
        self.closeBtn = UIButton.tk_createButton(title: "", titleStatu: .normal, imageName: "track_icon_back", imageStatu: .normal, supView: self.bgView, closure: { (make) in
            make.top.equalTo(bgView.snp.top).offset(Adapt(10))
            make.right.equalTo(bgView.snp.right).offset(Adapt(-10))
            make.width.height.equalTo(Adapt(30))
        })
        
        
        self.closeBtn.addTarget(self, action: #selector(hiddenAddView), for: .touchUpInside)
        
        self.startTrackBtn = UIButton.tk_createButton(title: "确定", titleStatu: .normal, imageName: "", imageStatu: .normal, supView: self.bgView, closure: {
            (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(Adapt(-40))
            make.centerX.equalTo(bgView.snp.centerX)
            make.height.equalTo(Adapt(50))
            make.width.equalTo(Adapt(250))
        })
        self.startTrackBtn.backgroundColor = UIColor.init(r: 55, g: 194, b: 207)
        self.startTrackBtn.layer.cornerRadius = 5
        self.startTrackBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.startTrackBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
        
    }

    @objc func start(){
        
        let data = textField.text!
        if data == "" {
            ProgressHUD.showError("内容为空")
        }else {
            ProgressHUD.showSuccess("修改成功")
            delegate?.passBookName(with:data)
            self.textField.text = ""
            self.hiddenAddView()
        }
    }
}
// MARK: - 键盘监听
extension AlterSginView: UITextFieldDelegate {
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "地点"  {
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
 
        print("22")
    }
 
    @objc func dismissKeyboard(){
        print("键盘成功关闭")
        self.endEditing(false)
    }
}
