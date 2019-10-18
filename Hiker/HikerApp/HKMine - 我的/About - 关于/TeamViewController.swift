//
//  TeamViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/15.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class TeamViewController: SubClassBaseViewController {

    
    var leftList = ["指导老师","产品","算法","后端","iOS端","界面设计","其他"]
    var rightList = ["邓晓军、刘强","张驰、李隽丰","张驰","张驰","张驰","李隽丰","游子欣"]
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.backgroundColor = backColor
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    

    func configUI() {
        view.addSubview(tableview)
        tableview.frame = CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight)
        self.navigation.item.title = "鸣谢"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
    }

}

extension TeamViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cellid = "setCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
        }
        cell?.textLabel?.text = leftList[indexPath.row]
        cell?.detailTextLabel?.text = rightList[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        //cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableview.deselectRow(at: indexPath, animated: true)
    }
}
