//
//  ConcernViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/18.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class ConcernViewController: UIViewController {

    var data = [User]()
    
    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "home_icon_back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        //tableview.register(BookCell.self, forCellReuseIdentifier: "bookCell")
        tableview.separatorStyle = .none
        tableview.backgroundColor = backColor
        return tableview
    }()
    
    convenience init(data:[User]) {
        self.init()
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    
    func configUI(){
        self.view.addSubview(tableview)
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.backgroundColor = .white
        view.backgroundColor = .white
        self.navigation.bar.isShadowHidden = true
                if #available(iOS 11.0, *) {
                    self.navigation.bar.prefersLargeTitles = true
                    self.navigation.item.largeTitleDisplayMode = .automatic
        }
        self.view.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        self.navigation.item.title = "关注"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)

        tableview.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(navigation.bar.snp.bottom).offset(20)
            make.bottom.equalTo(0)
        }
        
    }

    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }

}
extension ConcernViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "story\(indexPath.section)\(indexPath.row)"
        
        self.tableview.register(ConcernCell.self, forCellReuseIdentifier: identifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier , for: indexPath) as! ConcernCell
        cell.updateUI(with: data[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.deselectRow(at: indexPath, animated: true)
        
    }
    
}
