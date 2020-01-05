//
//  ViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import EachNavigationBar
import SwiftMessages
import ESTabBarController_swift
import ProgressHUD
import Alamofire
import HandyJSON
import SwiftyJSON



class MainViewController: UIViewController {
    
    var dissmissKeyboredTap = UITapGestureRecognizer()
    var requestEndFlag = false
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var userPwd: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        

        let url =  getLoginAPI(userID:  userID.text! , password:  userPwd.text! )
        
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
    
    @IBAction func RegisterBtn(_ sender: Any) {
//        let registerVC = RegisterViewController()
//        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    @IBAction func WeichatBtn(_ sender: Any) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        warning.configureContent(title: "不好意思啦", body: "微信登陆目前还未没有开放噢", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    @IBAction func QQBtn(_ sender: Any) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        warning.configureContent(title: "不好意思啦", body: "QQ登陆目前还未没有开放噢", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if #available(iOS 13.0, *) {
//            let margins = view.layoutMargins
//            var frame = view.frame
//            frame.origin.x = -margins.left
//            frame.origin.y = -margins.top
//            frame.size.width += margins.left + margins.right
//            frame.size.height += margins.top + margins.bottom
//            view.frame = frame
//        }
        configUI()
    }


    
    func configUI(){
        dissmissKeyboredTap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        view.addGestureRecognizer(dissmissKeyboredTap)
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
    }
    @objc func dismissKey(){
        self.view.endEditing(true)
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
    
    
    /// 异步数据请求同步化
    func waitingRequestEnd() {
        if Thread.current == Thread.main {
            while !requestEndFlag {
                RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.3))
            }
        } else {
            autoreleasepool {
                while requestEndFlag {
                    Thread.sleep(forTimeInterval: 0.3)
                }
            }
        }
    }
}


