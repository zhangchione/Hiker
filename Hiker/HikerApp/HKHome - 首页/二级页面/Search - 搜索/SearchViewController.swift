//
//  SearchViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import CollectionKit
import SnapKit
import SwiftMessages
import ProgressHUD

class SearchViewController: SubClassBaseViewController {

    var scrollview:UIScrollView!
    
    lazy var textfiled :UITextField = {
        let tf = UITextField()
        tf.placeholder = "想要了解什么"
        tf.delegate = self
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .go
       // tf.borderStyle = .roundedRect
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var tfBackView:UIView = {
       let vi = UIView()
        vi.backgroundColor = .white
        return vi
    }()
    
    lazy var backView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.init(r: 248, g: 248, b: 248)
        vi.layer.cornerRadius = 10
         return vi
    }()
    
    lazy var userLabel: UILabel = {
       let label = UILabel()
        label.text = "推荐用户"
        label.font = UIFont.init(name: "苹方-简 中黑体", size: 14)
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
        return label
    }()
    
    lazy var zanwu: UILabel = {
       let label = UILabel()
        label.text = "目前没有用户推荐噢~"
        label.font = UIFont.init(name: "苹方-简 中黑体", size: 14)
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
        return label
    }()
    
    lazy var historyBtn1:UIButton = {
        let btn = UIButton()
        btn.setTitle("广州", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.init(r: 58, g: 58, b: 58), for: .normal)
        btn.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(btn1), for: .touchUpInside)
        return btn
    }()
    
    lazy var historyBtn2:UIButton = {
        let btn = UIButton()
        btn.setTitle("澳大利亚", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.init(r: 58, g: 58, b: 58), for: .normal)
        btn.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(btn2), for: .touchUpInside)
        return btn
    }()
    
    lazy var clearBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "home_search_clear"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.init(r: 58, g: 58, b: 58), for: .normal)
        btn.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(clear), for: .touchUpInside)
        return btn
    }()
    
    fileprivate let dataSource = ArrayDataSource(data:[User]())
    fileprivate lazy var collectionView = CollectionView()

    
    var dismissKetboardTap = UITapGestureRecognizer()
    
    @objc func dismissKeyboard(){
        print("键盘成功关闭")
        self.view.endEditing(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configCV()
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configData()
        self.textfiled.becomeFirstResponder()
        if getHistory1() != nil {
            historyBtn1.setTitle(getHistory1(), for: .normal)
        }else {
            historyBtn1.isHidden = true
        }
        if getHistory2() != nil {
            historyBtn2.setTitle(getHistory2(), for: .normal)
        }else {
            historyBtn2.isHidden = true
        }
    }
 

}

/// objc

extension SearchViewController {
    @objc func btn1() {
        let word = historyBtn1.currentTitle!
        let vc = SearchContentViewController(word: word)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func btn2() {
        let word = historyBtn2.currentTitle!
        let vc = SearchContentViewController(word: word)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func clear() {
        UserDefaults.standard.removeObject(forKey: "history1")
        UserDefaults.standard.removeObject(forKey: "history2")
        ProgressHUD.showSuccess("记录删除成功")
        self.historyBtn1.isHidden = true
        self.historyBtn2.isHidden = true
    }
}

/// MRAK - 输入监听
extension SearchViewController:UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.content = textfiled.text
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        let word = textfiled.text!
        let vc = SearchContentViewController(word: word)
        self.navigationController?.pushViewController(vc, animated: true)
        
        if getHistory1() != nil {
            saveHistory2(history2: word)
        }else {
            saveHistory1(history1: word)
        }
        
        return true;

    }
    
}

/// MRAK - SetUp
extension SearchViewController {
    func configUI(){
        //左侧图片
        let vi = UIView()
       // vi.backgroundColor = .red
        let leftView = UIImageView(image: #imageLiteral(resourceName: "home_icon_ser"))
        //leftView.backgroundColor = .green
        leftView.contentMode = .center
        leftView.frame = CGRect(x: 4, y: 4, width: 20, height: 20)
        vi.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        vi.addSubview(leftView)
        textfiled.leftView = vi
        textfiled.leftViewMode = .always
        let scrollview =  UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigation.item.title = "搜索"
        view.backgroundColor = backColor
        view.addSubview(collectionView)
        view.addSubview(userLabel)

        view.addSubview(clearBtn)
        
        view.addSubview(historyBtn1)
        view.addSubview(historyBtn2)
        
        view.addSubview(tfBackView)
        tfBackView.addSubview(backView)
        backView.addSubview(textfiled)
        
        
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.isScrollEnabled = false
        
        collectionView.alwaysBounceVertical = false
        
        userLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(self.navigation.bar.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        collectionView.snp.makeConstraints{(make) in
            make.left.equalTo(view).offset(0)
            make.top.equalTo(userLabel.snp.bottom).offset(15)
            make.width.equalTo(TKWidth-15)
            make.height.equalTo(150)
        }

        
        tfBackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.centerY.equalTo(view.snp.bottom).offset(-376)
            make.height.equalTo(60)
        }
        
        backView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        textfiled.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.center.equalToSuperview()
            make.height.equalTo(30)
        }
        
        historyBtn1.snp.makeConstraints{(make) in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(tfBackView.snp.top).offset(-8)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        
        historyBtn2.snp.makeConstraints{(make) in
            make.left.equalTo(historyBtn1.snp.right).offset(20)
            make.bottom.equalTo(tfBackView.snp.top).offset(-8)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        clearBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.centerY.equalTo(historyBtn2)
            make.width.height.equalTo(30)
        }
        
    }
    
    func configCV() {
        let viewSource = ClosureViewSource(viewUpdater: {(view:SearchUserCell,data:User,index:Int) in
                view.updateUI(with:data)
            })
        
        let sizeSource = {(index:Int,data:User,collectionSize:CGSize) ->CGSize in
            return CGSize(width: 120, height: 150)
            }
              
        let provider = BasicProvider(
                dataSource: dataSource,
                viewSource: viewSource,
                sizeSource:sizeSource
            )
        provider.animator = ScaleAnimator()
        let layout = FlowLayout(spacing: 10,justifyContent: .end)
        provider.layout = layout
        provider.tapHandler = { context -> Void in
            let userVC = HKUserViewController(data: context.data)
            self.navigationController?.pushViewController(userVC, animated: true)
        }
        collectionView.provider = provider
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func configData(){
        let user1 = User(id: "263e68dd-1078-4f87-9427-64a63d58e125", username: "zhangchione", password: "zc123...", headPic: "https://www.hut-idea.top/images/20191021/09Hjz08IpmuD7bEvfywF.jpg", sgin: "做一个向往光和远方到程序员！", notes: 16, fans: 2, concern: 0, nickName: "小张同学", bgPic: "https://www.hut-idea.top/images/20191024/KCaLpDfeB3WeBhbmwvWw.jpg")
        
        let user2 = User(id: "7fd2061b-a4d7-490a-8ef1-5469256e5f72", username: "zhangchi3", password: "zc123", headPic: "https://www.hut-idea.top/images/20191024/WbYMIqkW0zudQgUEHtof.jpg", sgin: "行走在冬夜的冷风中～", notes: 11, fans: 2, concern: 1, nickName: "颜忆曦曦", bgPic: "https://www.hut-idea.top/images/20191024/mqX4Si7EKlr60I5XyKIc.jpg")
        
        let user3 = User(id: "b29440d4-3c89-4a20-9ccd-4d1545e38578", username: "zhangchi2", password: "zc123", headPic: "https://www.hut-idea.top/images/20191024/5XBBH8GdM9wjPu1x9pC3.jpg", sgin: "总得钟情点什么，比如对旅行的热爱。", notes: 13, fans: 0, concern: 1, nickName: "细微晨光", bgPic: "https://www.hut-idea.top/images/20191024/jCZrrEeqIFvHR90P7Cai.jpg")
        self.dataSource.data.removeAll()
        self.dataSource.data.append(user1)
        self.dataSource.data.append(user2)
        self.dataSource.data.append(user3)
        self.collectionView.reloadData()
    }

}




// 观察者模式
extension SearchViewController  {
    
        @objc func keyboardWillChangeFrame(note: Notification) {
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let endFrame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let y = endFrame.origin.y
            
            //计算工具栏距离底部的间距
            let margin = UIScreen.main.bounds.height - y
            UIView.animate(withDuration: duration) {
    //            键盘弹出
                if margin > 0 {
                    self.textfiled.frame.origin.y = self.textfiled.frame.origin.y - margin
                    print(self.textfiled.frame.origin.y)
                    print(margin)
                }
    //            键盘收起
                else {
                    self.textfiled.frame.origin.y = self.view.frame.height - 40
                    print("受气")
                }
            }
        }
}
