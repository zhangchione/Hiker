//
//  MainTabBarController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/26.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift


func goToApp(){
    let mainTabVar = mainTabBar()
    UIApplication.shared.keyWindow?.rootViewController = mainTabVar
    UIApplication.shared.keyWindow?.makeKeyAndVisible()
}

func logOutApp(){
    
    UserDefaults.standard.removeObject(forKey: "token")
    let rootViewController = UIStoryboard(name: "Main", bundle: nil)
        .instantiateInitialViewController()!
    let loginVC = MainNavigationController.init(rootViewController: rootViewController)
    loginVC.navigation.configuration.isEnabled = true
    UIApplication.shared.keyWindow?.rootViewController = loginVC
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
 //   tabBarController.tabBar.backgroundImage = UIImage(named: "tabColor")
   // tabBarController.tabBar.backgroundColor = .white
    
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
            let noteNav = NotesNavigationController.init(rootViewController: notesVC)
            noteNav.navigation.configuration.isEnabled = true
            noteNav.navigation.configuration.barTintColor = .white
            noteNav.navigation.configuration.tintColor = .white
            noteNav.modalPresentationStyle = .fullScreen
            tabBarController?.present(noteNav, animated: true, completion: nil)
        }
    }
    tabBarController.viewControllers = [homeNav,noteNav,mineNav]
    tabBarController.viewControllers?.first?.tabBarItem.imageInsets =  UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    tabBarController.viewControllers?.last?.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    
    return tabBarController
}
