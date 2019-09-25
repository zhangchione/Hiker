//
//  MineStoryViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit


class MineStoryViewController: UIViewController {
    public var count = 10
    public var datas:StoryModel?
    
    private let storyID = "MineSotryCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: storyID, bundle: nil), forCellReuseIdentifier: storyID)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI(){
        view.addSubview(self.tableView)
        self.tableView.frame = CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight - 120)
        glt_scrollView = tableView
    }

}

extension MineStoryViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return (datas?.story!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: storyID, for: indexPath) as! MineSotryCell
            
            configCell(cell, with: (datas?.story![indexPath.row])!)
            cell.selectionStyle = .none;
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return  100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("111")
        let model = datas?.story![indexPath.row]
        let vc = StoryViewController(model: model!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MineStoryViewController{
    
    func configCell(_ cell:MineSotryCell,with data:NotesModel){
        cell.img.image = UIImage(named: data.pics![0])
        cell.time.text = data.time
        cell.title.text = data.title
        cell.locations.text = "#" + (data.locations?.joined(separator: "、"))!
        if data.type == 2 {
            cell.personal.isHidden = true
        }
        print(data)
    }
}
