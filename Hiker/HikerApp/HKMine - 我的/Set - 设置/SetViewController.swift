//
//  SetViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class SetViewController: SubClassBaseViewController {
    @IBAction func Logout(_ sender: Any) {
        let rootViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController()!
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }


    func configUI(){
        self.view.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        self.navigation.item.title = "更多"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        self.scrollView.isScrollEnabled = true
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: TKWidth, height: 1000)
    }

}
extension SetViewController : UIScrollViewDelegate {
    
}
