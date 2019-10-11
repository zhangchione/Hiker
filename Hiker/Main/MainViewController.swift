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
                ProgressHUD.showSuccess("登陆成功")

                goToApp()
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

}


