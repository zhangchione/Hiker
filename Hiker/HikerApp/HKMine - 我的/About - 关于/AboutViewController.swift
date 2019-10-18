//
//  AboutViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/15.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import ProgressHUD

class AboutViewController: SubClassBaseViewController {
    
    @IBAction func commentScore(_ sender: Any) {
        let url = URL(string: "itms-apps://itunes.apple.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func function(_ sender: Any) {
        if let url = URL(string: "https://shimo.im/docs/VrWVWKCPVC9hKQpV") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func team(_ sender: Any) {
        let teamVC = TeamViewController()
        self.navigationController?.pushViewController(teamVC, animated: true)
        
    }
    
    @IBAction func newVersion(_ sender: Any) {
            ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        }
        ProgressHUD.showSuccess("已是最新版本")
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.isScrollEnabled = true
        scrollView.delegate = self
        configUI()
    }

    func configUI() {
        self.navigation.item.title = "关于"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        view.backgroundColor = backColor
    }

    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: TKWidth, height: TKHeight-88)
    }

}
extension AboutViewController : UIScrollViewDelegate {
    
}
