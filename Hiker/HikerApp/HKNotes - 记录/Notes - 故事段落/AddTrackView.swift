//
//  AddTrackView.swift
//  Tracks
//
//  Created by 张驰 on 2019/8/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import ProgressHUD
import UIKit

protocol TKAddTrackViewDelegate : class {
    func tk_reloadUI(with data: String)
}

class AddTrackView: UIView {
    
    var startDate: Date?
    var endDate: Date?
    var isTrackedStart:Bool = false
    var isTrackedEnd:Bool = false
    weak var delegate : TKAddTrackViewDelegate?
    // 键盘关闭点击
    var dismissKetboardTap = UITapGestureRecognizer()
    
    
    private lazy var bgView = UIView()
    private lazy var titleLab = UILabel()
    lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("开始", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        //    btn.contentHorizontalAlignment = .left
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(startTimeAction), for: .touchDown)
        return btn
    }()
    private lazy var lineBtnCenter:UIView = {
       let vi = UIView()
         vi.backgroundColor = .black
        return vi
    }()
    var endBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("结束", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        //     btn.contentHorizontalAlignment = .left
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(endTimeAction), for: .touchDown)
        return btn
    }()
    private lazy var closeBtn = UIButton()
    private lazy var locationIcon = UIImageView()
    lazy var locationTextField : UITextField = {
       let tf = UITextField()
        tf.text = "地点"
        tf.delegate = self
        return tf
    }()
    private lazy var line1 = UIView()
    private lazy var timeIcon = UIImageView()
    private lazy var line2 = UIView()
    
    private lazy var favIcon = UIImageView()
    lazy var favTextField : UITextField = {
        let tf = UITextField()
        tf.text = "想去哪玩~"
        tf.textColor = UIColor.gray
        tf.delegate = self
        return tf
    }()
    private lazy var line3 = UIView()
    
    private lazy var startTrackBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 33, g: 33, b: 33,alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenAddView))
        //self.addGestureRecognizer(tap)
        self.isHidden = true
        configUI()
        
        // 关闭键盘
        dismissKetboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.addGestureRecognizer(dismissKetboardTap)
        
        // 配置所有子视图
        TKinitWithAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TKinitWithAllView() {
        
    }
    // 隐藏窗口
    @objc func  hiddenAddView(){
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
}
// 配置UI
extension AddTrackView {
    private func configUI(){
        self.bgView  = UIView.tk_createView(bgClor: UIColor.white
            , supView: self, closure: { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(Adapt(-30))
            make.width.equalTo(TKWidth - Adapt(40))
            make.height.equalTo(TKHeight - Adapt(430))
        })
        self.bgView.layer.cornerRadius = 15
    
    
        self.titleLab = UILabel.tk_createLabel(text: "添加行程", textColor:  kBlack, font: BoldFontSize(24), supView: self.bgView, closure: { (make) in
        make.left.equalTo(Adapt(30))
        make.top.equalTo(Adapt(50))
        make.height.equalTo(Adapt(32))
        })
        
        self.locationIcon = UIImageView.tk_createImageView(imageName: "home_addtrack_location", supView: self.bgView, closure: {
            (make) in
            make.left.equalTo(Adapt(30))
            make.top.equalTo(titleLab.snp.bottom).offset(Adapt(30))
            make.height.equalTo(Adapt(25))
            make.width.equalTo(Adapt(18.5))
        })

        self.bgView.addSubview(locationTextField)
        self.locationTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationIcon.snp.centerY)
            make.height.equalTo(Adapt(40))
            make.width.equalTo(Adapt(250))
            make.left.equalTo(locationIcon.snp.right).offset(30)
        }
        self.line1 = UIView.tk_createView(bgClor: UIColor.gray, supView: bgView, closure: { (make) in
            make.left.equalTo(Adapt(30))
            make.right.equalTo(Adapt(-30))
            make.height.equalTo(Adapt(1))
            make.top.equalTo(locationIcon.snp.bottom).offset(15)
        })
        
        self.timeIcon = UIImageView.tk_createImageView(imageName: "home_addtrack_calendar", supView: self.bgView, closure: {
            (make) in
            make.left.equalTo(Adapt(30))
            make.top.equalTo(line1.snp.bottom).offset(Adapt(40))
            make.height.equalTo(Adapt(25))
            make.width.equalTo(Adapt(23))
        })
        
        self.bgView.addSubview(startBtn)

        startBtn.snp.makeConstraints { (make) in
            make.left.equalTo(timeIcon.snp.right).offset(20)
            make.centerY.equalTo(timeIcon.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        self.bgView.addSubview(lineBtnCenter)
        lineBtnCenter.snp.makeConstraints { (make) in
            make.left.equalTo(startBtn.snp.right).offset(10)
            make.centerY.equalTo(timeIcon.snp.centerY)
            make.width.equalTo(8)
            make.height.equalTo(2)
        }
        self.bgView.addSubview(endBtn)
       
        endBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineBtnCenter.snp.right).offset(10)
            make.centerY.equalTo(timeIcon.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        
        self.line2 = UIView.tk_createView(bgClor: UIColor.gray, supView: bgView, closure: { (make) in
            make.left.equalTo(Adapt(30))
            make.right.equalTo(Adapt(-30))
            make.height.equalTo(Adapt(1.5))
            make.top.equalTo(timeIcon.snp.bottom).offset(Adapt(15))
        })
        
        self.line2.backgroundColor = UIColor.init(r: 55, g: 194, b: 207)
        
        self.favIcon = UIImageView.tk_createImageView(imageName: "home_addtrack_fav", supView: self.bgView, closure: {
            (make) in
            make.left.equalTo(Adapt(30))
            make.top.equalTo(line2.snp.bottom).offset(Adapt(40))
            make.height.equalTo(Adapt(25))
            make.width.equalTo(Adapt(23))
        })
        self.bgView.addSubview(favTextField)
        self.favTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(favIcon.snp.centerY)
            make.height.equalTo(Adapt(40))
            make.width.equalTo(Adapt(250))
            make.left.equalTo(locationIcon.snp.right).offset(30)
        }
        
        self.line3 = UIView.tk_createView(bgClor: UIColor.gray, supView: bgView, closure: { (make) in
            make.left.equalTo(Adapt(30))
            make.right.equalTo(Adapt(-30))
            make.height.equalTo(Adapt(1))
            make.top.equalTo(favIcon.snp.bottom).offset(15)
        })
        
        self.closeBtn = UIButton.tk_createButton(title: "", titleStatu: .normal, imageName: "track_icon_back", imageStatu: .normal, supView: self.bgView, closure: { (make) in
            make.top.equalTo(bgView.snp.top).offset(Adapt(20))
            make.right.equalTo(bgView.snp.right).offset(Adapt(-20))
            make.width.height.equalTo(Adapt(30))
        })
        self.closeBtn.addTarget(self, action: #selector(hiddenAddView), for: .touchUpInside)
        
        self.startTrackBtn = UIButton.tk_createButton(title: "开启我的旅程", titleStatu: .normal, imageName: "", imageStatu: .normal, supView: self.bgView, closure: {
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
    
    func configCV(){
        
    }
    
    @objc func start(){
        
        
    }
    
    @objc func startTimeAction() {
        let picker = QDatePicker { (date: Date) in
            self.startBtn.setTitle("\(date.formatterDate(formatter: "yyyy.MM.dd"))", for: .normal)
            self.isTrackedStart = true
            self.startDate = date
        }
        picker.maxLimitDate = self.endDate
        picker.datePickerStyle = .YMD
        picker.themeColor = UIColor.init(r: 55, g: 194, b: 207)
        picker.pickerStyle = .datePicker
        picker.animationStyle = .styleDefault
        picker.show()
    }
    @objc func endTimeAction() {
        let picker = QDatePicker { (date: Date) in
            let enddate = date.formatterDate(formatter: "yyyy.MM.dd")
            self.endBtn.setTitle(enddate, for: .normal)
            self.isTrackedEnd = true
            self.endDate = date
            print(enddate)
        }
        picker.minLimitDate = self.startDate
        picker.datePickerStyle = .YMD
        picker.themeColor = UIColor.init(r: 55, g: 194, b: 207)
        picker.pickerStyle = .datePicker
        picker.animationStyle = .styleDefault
        picker.show()
    }
}
// MARK: - 键盘监听
extension AddTrackView: UITextFieldDelegate {
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "地点"  {
//            self.line1.backgroundColor = UIColor.init(r: 55, g: 194, b: 207)
//            print("11")
        }
        if textField.text == "想去哪玩~" {
            self.line3.backgroundColor = UIColor.init(r: 55, g: 194, b: 207)
            print("想去哪玩~")
        }
        print("11")
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
