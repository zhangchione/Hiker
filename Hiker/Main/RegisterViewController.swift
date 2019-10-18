//
//  NextViewController.swift
//  UIViewController+NavigationBar
//
//  Created by Pircate on 2018/3/26.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import UIKit
import ProgressHUD
import EachNavigationBar
import SwiftMessages
import ESTabBarController_swift
import Alamofire
import HandyJSON
import SwiftyJSON

class RegisterViewController: UIViewController {
    

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userId: UITextField!
    
    @IBOutlet weak var pwd: UITextField!
    
    @IBOutlet weak var sendCodes: TimerButton!
    
    @IBAction func RegisterBtn(_ sender: Any) {
        
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "home_icon_back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    @IBAction func registerBtn(_ sender: Any) {

        if pwd.text! != password.text {
            ProgressHUD.showError("两次密码不一致")
        }else {
            Alamofire.request(getRegisterAPI(userID: userId.text!, password: pwd.text!)).responseJSON { (response) in
                guard response.result.isSuccess else {
                    ProgressHUD.showError("网络请求错误"); return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    guard json["msg"] == "ok" else {
                        ProgressHUD.showError("注册失败")
                        return
                    }
                    self.gotoApp()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        sendCode.addTarget(self, action: #selector(send), for: .touchUpInside)

        configUI()

    }
    

    
    func configUI(){
//        sendCodes.setup("获取验证码", timeTitlePrefix: "剩余")
//        sendCodes.clickBtnEvent = {
//            () -> Void in
//
//            if !self.sendCodes.isWorking {
//                print("正在获取验证码")
//
//                self.sendCodes.isWorking = true
//            }
//        }
//        sendCodes.setTitleColor(UIColor.blue, for: .normal)
        let dissmissKeyboredTap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        view.addGestureRecognizer(dissmissKeyboredTap)
        
        self.navigationItem.title = "注册"
        self.navigation.bar.isShadowHidden = true
        //self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        view.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
    }
    
    @objc func dismissKey(){
        self.view.endEditing(true)
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    func gotoApp() {
        let url =  getLoginAPI(userID:  userId.text! , password:  pwd.text! )
        ProgressHUD.show("登陆中")
        Alamofire.request(url).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["msg"] == "token获取成功，有效期30天" else {
                    ProgressHUD.showError("用户名或密码错误")
                    return
                }
                print(json)
                saveToken(token: json["data"].string!)
                self.getUserInfo()

                print("token为:",getToken()!)
            }
        }
    }
    
    func getUserInfo(){
        Alamofire.request(getUserInfoAPI()).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)

                saveUserId(userId: json["data"]["id"].stringValue)
                saveHeadPic(headPic: json["data"]["headPic"].stringValue)
                saveNickName(nickName: json["data"]["nickName"].stringValue)
                print("userid 存储成功为：",getUserId())
                print(getHeadPic())
                print(getNickName())
                ProgressHUD.showSuccess("登陆成功")
                goToApp()
            }
        }

    }
    
}

extension RegisterViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
