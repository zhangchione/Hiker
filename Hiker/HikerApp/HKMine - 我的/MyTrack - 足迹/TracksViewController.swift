//
//  TracksViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/22.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class TracksViewController: UIViewController ,DataToEasyDelegate {
        let keyMap = ["building":["塔","高楼","小洋房","别墅","学校"],
                      "food":["美食","食品","小吃","面","汤包"],
                      "landscape":["美景","山","水","湖","湖泊","江","白云"],
                      "animal":["猫","狗","猴子"],
                      "night_scene":["夜","深夜","傍晚","黄昏"],
                      "face":["人"]
                    ]
    
        lazy var tipLabel = UILabel()
        func recognize(current: Int, max: Int) {
            
                DispatchQueue.main.async {
                           self.tipLabel.text = "第一次配图需要给系统照片分类，正在分类图片\(current)/\(max)，如果数字卡死，请重启App"
    
            }
        }
        var photoDataManager: PhotoDataManager
    
    
        init(_ photoDataManager: PhotoDataManager) {
        self.photoDataManager = photoDataManager
        super.init(nibName: nil, bundle: nil)
        self.photoDataManager.dataToEasyDelegate = self
        }
    
        required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        view.addSubview(tipLabel)
        tipLabel.numberOfLines = 0
        tipLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
