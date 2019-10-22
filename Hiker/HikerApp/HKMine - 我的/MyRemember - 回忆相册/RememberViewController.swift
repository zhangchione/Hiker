//
//  RememberViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/22.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import RxSwift
import CollectionKit
//import SwiftyUserDefaults

class RememberViewController: UIViewController,DataToEasyDelegate  {
    
    lazy var tipLabel = UILabel()
    func recognize(current: Int, max: Int) {
            
                DispatchQueue.main.async {
                           self.tipLabel.text = "第一次配图需要给系统照片分类，正在分类图片\(current)/\(max)，如果数字卡死，请重启App"
    
            }
    }
    var photoDataManager: PhotoDataManager
    // RxSwift 销毁
    let disposeBag = DisposeBag()
    
    init(_ photoDataManager: PhotoDataManager) {
        self.photoDataManager = photoDataManager
        super.init(nibName: nil, bundle: nil)
        self.photoDataManager.dataToEasyDelegate = self
    }
    
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var collectionView = CollectionView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
                tipLabel.numberOfLines = 0
    }
    
    func configUI(){
    }
    

    


    
}

