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
    let storyID = "WriteStoryCell"
    // tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: StorySementCellID, bundle: nil), forCellReuseIdentifier: StorySementCellID)
        
        tableView.register(WriteStoryCell.self, forCellReuseIdentifier: storyID)
        tableView.separatorStyle = .none
        //tableView.backgroundColor = .white
        
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
        cellIsPhoto.append(false)
        //cellIsPhoto[0] = false
        dismissKetboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKetboardTap)
        
        view.backgroundColor = .white
        view.addSubview(leftBarButton)
        
        view.addSubview(self.tableView)
        view.addSubview(addStoryBtn)
        self.tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view).offset(100)
            make.width.equalTo(TKWidth)
            make.height.equalTo(TKHeight-88)
        }

        
    }
    
    var dismissKetboardTap = UITapGestureRecognizer()
    
    
    @objc func dismissKeyboard(){
        print("键盘成功关闭")
        self.view.endEditing(false)
    }
    

    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    
    }
    public var topColor = UIColor.white
    var content1 = "快记录一下吧~"
    var count  = 1;
    var cellDectionary = [Dictionary<Int, Bool>]()
    var cellIsPhoto = [Bool]()
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
            print(cellIsPhoto)
              
            
            let identifier = "story\(indexPath.section)\(indexPath.row)"
            self.tableView.register(WriteStoryCell.self, forCellReuseIdentifier: identifier)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WriteStoryCell
            cell.delegate = self
            if indexPath.row != count-1 {
                cell.nextBtn.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if cellIsPhoto[indexPath.row] {
            return 400
        }
        return  250
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = WriteHeaderReusableView()
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

extension NotesViewController: WriteStoryDelegate{
    
    func storyWriteClick(content: String, location: String, time: String) {
        //print(content,location,time)
        add()
    }
    
    
    
    @objc func add(){
        print("11")
        
        self.cellIsPhoto[count - 1] = true
        self.count += 1
        self.cellIsPhoto.append(false)
        
        self.tableView.reloadData()
    }
}


