//
//  NotesViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class NotesViewController: CustomTransitionViewController {

    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:20, y:44, width:40, height: 40)
        button.setImage(UIImage(named: "home_icon_back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    let StorySementCellID = "WriteCell"
    // tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: StorySementCellID, bundle: nil), forCellReuseIdentifier: StorySementCellID)
        //tableView.register(WriteCell.self, forCellReuseIdentifier: StorySementCellID)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // 左边返回按钮
    private lazy var addStoryBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("下一段", for: .normal)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(leftBarButton)
        
        view.addSubview(self.tableView)
        view.addSubview(addStoryBtn)
        self.tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view).offset(100)
            make.width.equalTo(TKWidth)
            make.height.equalTo(count * 300)
        }

        
    }
    

    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    
    }
    public var topColor = UIColor.white
    var content1 = "快记录一下吧~"
    var count  = 1;
}

extension NotesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: StorySementCellID , for: indexPath) as! WriteCell
            cell.selectionStyle = .none;
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .red
            }
            cell.next1.addTarget(self, action: #selector(add), for: .touchUpInside)
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return  300
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension NotesViewController{
    @objc func add(){
        print("11")
        self.count += 1
        
        
        self.tableView.reloadData()
    }
}


