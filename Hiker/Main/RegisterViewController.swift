//
//  NextViewController.swift
//  UIViewController+NavigationBar
//
//  Created by Pircate on 2018/3/26.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    
    
    @IBAction func SendCodeBtn(_ sender: Any) {
        
    }
    
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        

        configUI()

    }
    
    func configUI(){
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        view.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RegisterViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}