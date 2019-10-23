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
        let user1 = User(id: "263e68dd-1078-4f87-9427-64a63d58e125", username: "zhangchione", password: "zc123...", headPic: "https://www.hut-idea.top/images/20191014/cIt7MVKFLwK186wjWeCj.png", sgin: "喜欢远方", notes: 6, fans: 1, concern: 0, nickName: "小张同学", bgPic: "https://uploadfiles.nowcoder.com/files/20190814/6658561_1565778336259_120x120.png")
        
        let user2 = User(id: "20883ba0-2d47-4be0-afe1-82ed9ea626fd", username: "zc123", password: "123456", headPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568805954241&di=92427105ce91bac17ca2ef9fa75e1326&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180909%2Ffcc86038b8c0410f87aee5229aa092c3.jpeg", sgin: "爱旅行,爱旅拍", notes: 0, fans: 2, concern: 1, nickName: "旅中人", bgPic: "https://uploadfiles.nowcoder.com/files/20190814/6658561_1565778336259_120x120.png")
        
        let user3 = User(id: "75f03a3c-2398-4607-ae0c-be1224f54c56", username: "cone", password: "zc123...", headPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568805954241&di=92427105ce91bac17ca2ef9fa75e1326&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180909%2Ffcc86038b8c0410f87aee5229aa092c3.jpeg", sgin: "爱旅行的小张同学", notes: 1, fans: 0, concern: 1, nickName: "Cone噢", bgPic: "https://uploadfiles.nowcoder.com/files/20190814/6658561_1565778336259_120x120.png")
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
