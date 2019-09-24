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
        
        self.goToApp()
//        let url = "http://120.77.151.36:8080/login?username=" + userID.text! + "&password=" + userPwd.text!
//
//        ProgressHUD.show("登陆中")
//
//        Alamofire.request(url).responseJSON { (response) in
//
//            guard response.result.isSuccess else {
//                ProgressHUD.showError("网络请求错误"); return
//            }
//            if let value = response.result.value {
//                let json = JSON(value)
//                guard json["msg"] == "token获取成功，有效期30天" else {
//                    ProgressHUD.showError("用户名或密码错误");  return
//                }
//                saveToken(token: json["data"].string!)
//                ProgressHUD.showSuccess("登陆成功")
//
//
//                print("token为:",getToken()!)
//            }
//        }
//        print("登陆信息为：",userID.text!,userPwd.text!)

        
        
    }
    
    @IBAction func RegisterBtn(_ sender: Any) {
//        let registerVC = RegisterViewController()
//        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    @IBAction func WeichatBtn(_ sender: Any) {
        
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
        dissmissKeyboredTap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        view.addGestureRecognizer(dissmissKeyboredTap)
        configUI()
    }

    @objc func dismissKey(){
        self.view.endEditing(true)
    }
    
    func configUI(){
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
    }
    
    func goToApp(){
        let mainTabVar = self.mainTabBar()
        UIApplication.shared.keyWindow?.rootViewController = mainTabVar
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    func mainTabBar() -> UITabBarController {
        let homeVC = HKHomeViewController()
        let noteVC = UIViewController()
        let mineVC = HKMineViewController()
        
        homeVC.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "home_tab_unselected"), selectedImage: UIImage(named: "home_tab_selected"))
        
        
        mineVC.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "mine_tab_unselected"), selectedImage: UIImage(named: "mine_tab_selected"))
        
        noteVC.tabBarItem = ESTabBarItem.init(CenterTabBarItem(), title: nil, image: UIImage(named: "add_tab"), selectedImage: UIImage(named: "add_tab"))
        
        
        let homeNav = MainNavigationController.init(rootViewController: homeVC)
        let mineNav = MainNavigationController.init(rootViewController: mineVC)
        let noteNav = MainNavigationController.init(rootViewController: noteVC)
        
        
        homeNav.navigation.configuration.isEnabled = true
        homeNav.navigation.configuration.barTintColor = backColor
        homeNav.navigation.configuration.tintColor = backColor
        
        mineNav.navigation.configuration.isEnabled = true
        mineNav.navigation.configuration.barTintColor = .white
        mineNav.navigation.configuration.tintColor = .white
        
        
        
        if #available(iOS 11.0, *) {
            homeNav.navigation.prefersLargeTitles()
        }
        if #available(iOS 11.0, *) {
            mineNav.navigation.prefersLargeTitles()
        }
        
        
        let tabBarController = ESTabBarController()
        tabBarController.tabBar.shadowImage = UIImage(named: "tabbarColor")
        tabBarController.tabBar.backgroundImage = UIImage(named: "tabColor")
        tabBarController.tabBar.backgroundColor = .white
        
        
        
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 1 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let notesVC = TitleController()
                let noteNav = MainNavigationController.init(rootViewController: notesVC)
                noteNav.navigation.configuration.isEnabled = true
                noteNav.navigation.configuration.barTintColor = .white
                noteNav.navigation.configuration.tintColor = .white
                tabBarController?.present(noteNav, animated: true, completion: nil)
            }
        }
        tabBarController.viewControllers = [homeNav,noteNav,mineNav]
        tabBarController.viewControllers?.first?.tabBarItem.imageInsets =  UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        tabBarController.viewControllers?.last?.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        return tabBarController
    }
}

