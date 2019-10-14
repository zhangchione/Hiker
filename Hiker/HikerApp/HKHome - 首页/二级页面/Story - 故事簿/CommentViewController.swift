//
//  CommentViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/14.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class CommentViewController: UIViewController {

    private var datas = [Comments]()
    private var noteId = 0
    var requestEndFlag = false
    
    private lazy var commentView : CommentView = {
        let loginView = CommentView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight))
        loginView.delegate = self
        return loginView
    }()
    
    lazy var closeBtn:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "track_icon_back"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var commentBtn:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "home_detialstory_comment"), for: .normal)
        btn.addTarget(self, action: #selector(comment), for: .touchUpInside)
        return btn
    }()
    
    lazy var label:UILabel = {
       let label = UILabel()
        label.textColor = UIColor.init(r: 64, g: 102, b: 214)
        label.font = UIFont.init(name: "苹方-简 中黑体", size: 20)
        return label
    }()
    
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(CommentCell.self, forCellReuseIdentifier: "commentcell")
        tableview.separatorStyle = .none
        tableview.backgroundColor = .white
        return tableview
    }()
    
    
    convenience init(data:[Comments],noteId:Int) {
        self.init()
        self.datas = data
        self.noteId = noteId
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
    }
    

    func configUI(){
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(closeBtn)
        view.addSubview(tableview)
        view.addSubview(commentBtn)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(50)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(view).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
 
        tableview.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.height.equalTo(TKHeight - 100)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.bottom.equalTo(-44)
            make.width.height.equalTo(60)
        }
        
    }
    func configData(){
        self.label.text = "评论（\(datas.count)）"
    }
}

extension CommentViewController {
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func comment() {
        UIApplication.shared.keyWindow?.addSubview(self.commentView)
        self.commentView.showAddView()
    }
}

extension CommentViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "story\(indexPath.section)\(indexPath.row)"
        
        self.tableview.register(CommentCell.self, forCellReuseIdentifier: identifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier , for: indexPath) as! CommentCell
        cell.updateUI(with: datas[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 65 + getTextHeigh(textStr: datas[indexPath.row].content, font: UIFont.systemFont(ofSize: 15), width: TKWidth-140)
        return height
    }
    
}
extension CommentViewController {
    // 获取 content 高度
    fileprivate func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size,options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedString.Key : Any] , context:nil).size
        return stringSize.height
    }
}

extension CommentViewController:  CommentDelegate{
    func passBookName(with comment: Comments) {
        self.datas.append(comment)
        self.tableview.reloadData()
        let content = comment.content
        postCommet(noteId: self.noteId, content: content)
    }
    
    func postCommet(noteId:Int,content:String) {
        let dic = ["noteId":noteId,"content":content] as [String : Any]
        Alamofire.request(getCommentAPI(), method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
        guard response.result.isSuccess else {
            ProgressHUD.showError("发布游记网络请求错误"); return
        }
        if let value = response.result.value {
            let json = JSON(value)
            print(json)
                self.requestEndFlag = true
            }
        }
        waitingRequestEnd()
        self.requestEndFlag =  false
    }
    
    /// 异步数据请求同步化
    func waitingRequestEnd() {
        if Thread.current == Thread.main {
            while !requestEndFlag {
                RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.3))
            }
        } else {
            autoreleasepool {
                while requestEndFlag {
                    Thread.sleep(forTimeInterval: 0.3)
                }
            }
        }
    }
}
