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
        UserDefaults.standard.removeObject(forKey: "content")
        UserDefaults.standard.removeObject(forKey: "time")
        UserDefaults.standard.removeObject(forKey: "pic")
        UserDefaults.standard.removeObject(forKey: "location")
        UserDefaults.standard.removeObject(forKey: "tags")
        
        //UserDefaults.standard.removeObject(forKey: "token")
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
            //loginVC.navigation.configuration.isEnabled = true
            self.window!.rootViewController = loginVC
            print("没有,进入登录界面初始化")
        }
        //self.setDynamicGuidePage()
        
        

 
        
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
    func setDynamicGuidePage() {
         let imageNameArray: [String] = ["123.gif"]
         let guideView = HHGuidePageHUD.init(imageNameArray: imageNameArray, isHiddenSkipButton: false)
         self.window?.rootViewController?.view.addSubview(guideView)
     }
    func setVideoGuidePage() {
        let urlStr = Bundle.main.path(forResource: "12343.mp4", ofType: nil)
        let videoUrl = NSURL.fileURL(withPath: urlStr!)
        let guideView = HHGuidePageHUD.init(videoURL: videoUrl, isHiddenSkipButton: false)
        self.window?.rootViewController?.view.addSubview(guideView)
    }
}

