//
//  AppDelegate.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import EachNavigationBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainTabVar = mainTabBar()
        window?.rootViewController = mainTabVar
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    func mainTabBar() -> UITabBarController {
        let homeVC = HKHomeViewController()
        let noteVC = UIViewController()
        let mineVC = HKMineViewController()
        
        homeVC.tabBarItem.image = UIImage(named: "home_tab_unselected")
        homeVC.tabBarItem.selectedImage = UIImage(named: "home_tab_selected")
        noteVC.tabBarItem.image = UIImage()
        mineVC.tabBarItem.image = UIImage(named: "mine_tab_unselected")
        mineVC.tabBarItem.selectedImage = UIImage(named: "mine_tab_selected")

        let homeNav = MainNavigationController.init(rootViewController: homeVC)
        let mineNav = MainNavigationController.init(rootViewController: mineVC)
        let noteNav = MainNavigationController.init(rootViewController: noteVC)
        
        homeNav.navigation.configuration.isEnabled = true
        homeNav.navigation.configuration.barTintColor = backColor
        homeNav.navigation.configuration.tintColor = backColor
        
        if #available(iOS 11.0, *) {
            homeNav.navigation.prefersLargeTitles()
        }
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeNav,noteNav,mineNav]
        
        tabBar.viewControllers?.first?.tabBarItem.imageInsets =  UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        tabBar.viewControllers?.last?.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)

        tabBar.tabBar.backgroundImage = UIImage(named: "tabColor")
        tabBar.tabBar.shadowImage = UIImage(named: "tabbarColor")
        
        tabBar.tabBar.backgroundColor = .white
                return tabBar
    }
    
}

