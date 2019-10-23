//
//  BaseViewController.swift
//  Show
//
//  Created by nine on 2018/9/11.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
    }

    func configNav() {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
//      navigationItem.backBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .white
        
    }

}
