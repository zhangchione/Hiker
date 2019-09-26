//
//  AppDelegate.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import EachNavigationBar

import ESTabBarController_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        let rootVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
//        UIApplication.shared.keyWindow?.rootViewController = rootVc
//        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
        if getToken() != nil {
            let mainTabVar = mainTabBar()
            window?.rootViewController = mainTabVar
            window?.makeKeyAndVisible()
            print("已经拥有账号")
        }else {
        
            let rootViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateInitialViewController()!
            let loginVC = MainNavigationController.init(rootViewController: rootViewController)
            loginVC.navigation.configuration.isEnabled = true
            self.window!.rootViewController = loginVC
            
            print("没有,进入登录界面初始化")
        }
        
        


        
//        UIApplication.shared.keyWindow?.rootViewController = rootVc
//        UIApplication.shared.keyWindow?.makeKeyAndVisible()

//         window?.rootViewController = rootVc
//         window?.makeKeyAndVisible()
//        let mainTabVar = mainTabBar()
//        window?.rootViewController = mainTabVar
//        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

}

