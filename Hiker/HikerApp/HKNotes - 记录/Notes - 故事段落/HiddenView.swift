//
//  HiddenView.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import ProgressHUD

protocol selectBookDelegate : class {
    func passBookData(with name: String,id:Int)
}

class HiddenView: UIView {
    
    // 代理
    weak var delegate:selectBookDelegate?
    
    private lazy var addBookView : AddBookView = {
        let loginView = AddBookView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight))
        loginView.delegate = self
        return loginView
    }()
    
    // 故事簿
    var bookName: String?
    
    // 单选
    var selectIndex: IndexPath?
    
    private lazy var bgView = UIView()
    private lazy var titleLab = UILabel()
    private lazy var line1 = UIView()
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(BookCell.self, forCellReuseIdentifier: "bookCell")
        tableview.separatorStyle = .none
        tableview.backgroundColor = .white
        
        return tableview
    }()
    private lazy var closeBtn = UIButton()
    private lazy var addBookBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "note_add_story"), for: .normal)
        btn.setTitle("添加故事本", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.init(r: 204, g: 204, b: 204).cgColor
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(addBook), for: .touchUpInside)
        return btn
    }()
    
    private lazy var startTrackBtn = UIButton()
    
    var data = [BookModel]()
//    convenience init(data:[String]) {
//        self.data = data
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 33, g: 33, b: 33,alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenAddView))
        //self.addGestureRecognizer(tap)
        self.isHidden = true
        configUI()
        // 配置所有子视图
        TKinitWithAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TKinitWithAllView() {
        
    }
    // 隐藏窗口
    @objc func  hiddenAddView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
            self.bgView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (isSuccess) in
            
            self.isHidden = true
        }
    }
    // 显示窗口
    func showAddView() {
        self.alpha = 0.0
        self.isHidden = false
        self.bgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.bgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (isSuccess) in
        }
    }
    
    func configUI(){
        self.bgView  = UIView.tk_createView(bgClor: UIColor.white
                , supView: self, closure: { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(self.snp.centerY).offset(Adapt(-30))
                make.width.equalTo(TKWidth - Adapt(40))
                make.height.equalTo(TKHeight - Adapt(430))
        })
        self.bgView.layer.cornerRadius = 15
    
        self.titleLab = UILabel.tk_createLabel(text: "收录到", textColor:  kBlack, font: BoldFontSize(24), supView: self.bgView, closure: { (make) in
            make.left.equalTo(Adapt(30))
            make.top.equalTo(Adapt(50))
            make.height.equalTo(Adapt(32))
        })
        self.bgView.addSubview(addBookBtn)
        
        addBookBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgView.snp.right).offset(-10)
            make.centerY.equalTo(titleLab.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        self.line1 = UIView.tk_createView(bgClor: UIColor.init(r: 238, g: 238, b: 238), supView: bgView, closure: { (make) in
            make.left.equalTo(Adapt(30))
            make.right.equalTo(Adapt(0))
            make.height.equalTo(Adapt(1))
            make.top.equalTo(titleLab.snp.bottom).offset(5)
        })
        
        self.bgView.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-10)
            make.top.equalTo(line1.snp.bottom).offset(10)
            make.height.equalTo(240)
        }
        self.closeBtn = UIButton.tk_createButton(title: "", titleStatu: .normal, imageName: "track_icon_back", imageStatu: .normal, supView: self.bgView, closure: { (make) in
            make.top.equalTo(bgView.snp.top).offset(Adapt(10))
            make.right.equalTo(bgView.snp.right).offset(Adapt(-10))
            make.width.height.equalTo(Adapt(30))
        })
        self.closeBtn.addTarget(self, action: #selector(hiddenAddView), for: .touchUpInside)
        
        self.startTrackBtn = UIButton.tk_createButton(title: "确定", titleStatu: .normal, imageName: "", imageStatu: .normal, supView: self.bgView, closure: {
            (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(Adapt(-40))
            make.centerX.equalTo(bgView.snp.centerX)
            make.height.equalTo(Adapt(50))
            make.width.equalTo(Adapt(250))
        })
        self.startTrackBtn.backgroundColor = UIColor.init(r: 55, g: 194, b: 207)
        self.startTrackBtn.layer.cornerRadius = 5
        self.startTrackBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.startTrackBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
        
    }
}

extension HiddenView {
    @objc func addBook(){
        UIApplication.shared.keyWindow?.addSubview(self.addBookView)
        self.addBookView.showAddView()
    }
    
    @objc func start(){
        

        self.hiddenAddView()
        delegate?.passBookData(with: data[selectIndex?.row ?? 0].name,id: data[selectIndex?.row ?? 0].id)

    }
    @objc  func kong() {
        
    }
}

extension HiddenView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookCell
        cell.updateUI(with: data[indexPath.row])
        if selectIndex == indexPath {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableview.deselectRow(at: indexPath, animated: true)
        
        if selectIndex == nil {
            selectIndex = indexPath
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
        }else {
            if selectIndex == indexPath {
                let celled = tableView.cellForRow(at: selectIndex!)
                celled?.accessoryType = .none
                selectIndex = nil
            }else {
            
            let celled = tableView.cellForRow(at: selectIndex!)
            celled?.accessoryType = .none
            selectIndex = indexPath
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            }
        }
    }
    
}

extension HiddenView : AddBookDelegate {
    func passBookName(with data: String) {
        self.bookName = data
        self.data.append(BookModel(name: data, num: 0))
        self.tableview.reloadData()
    }
}
