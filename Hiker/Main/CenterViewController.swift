//
//  CenterViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/17.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
    
    var photoDataManager: PhotoDataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    init(_ photoDataManager: PhotoDataManager) {
        self.photoDataManager = photoDataManager
        super.init(nibName: nil, bundle: nil)
    }

    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
