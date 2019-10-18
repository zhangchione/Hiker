//
//  HKUserViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/15.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import LTScrollView
import PopMenu
import AudioToolbox
import HandyJSON
import SwiftyJSON
import Alamofire
import ProgressHUD


private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

class HKUserViewController: UIViewController {
    

    convenience init(data:User) {
        self.init()
        self.userData = data
        
        
    }
    
    var userData:User?
    var storyData:[StoryModel]?
    var concernData:[User]?
    var fansData: [User]?
    
    var mydata = [String]()
    
    var requestEndFlag = false
    var imgPricker:UIImagePickerController!
    private  var viewControllers = [UIViewController]()
    private  var titles = [String]()
 
    
    private lazy var alterSginView : AlterSginView = {
        let loginView = AlterSginView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight))
        loginView.delegate = self
        return loginView
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = false
        layout.titleViewBgColor = .white
        layout.titleSelectColor = UIColor.init(r: 0, g: 0, b: 0)
        layout.bottomLineColor = UIColor.init(r: 64, g: 223, b: 238)
        layout.sliderHeight = 48
        layout.lrMargin = 20
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        print(statusBarH)
        let Y: CGFloat = statusBarH + 88
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y ) : view.bounds.height - Y
        return CGRect(x: 0, y: statusBarH, width: view.bounds.width, height: H+88)
    }

    // MARK - 右边功能按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
         button.frame = CGRect(x:10, y:0, width:40, height: 40)
        button.addTarget(self, action: #selector(set), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "mine_icon_set"), for: .normal)
        return button
    }()
    
    // 左边返回按钮
    lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "home_icon_backwhite"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getMyConcernUser()
        configUI()
        configData()

    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           // configuserData()
        
    }
    
    func getMyConcernUser() {
        Alamofire.request(getAttentionAPI(userId: getUserId()!)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<ConcernsModel>.deserializeFrom(json: json.debugDescription){
                    if let datas = obj.data {
                        for data in datas {
                            self.mydata.append(data.id)
                        }
                    self.requestEndFlag = true

                    }
                }
            }
        }
        self.waitingRequestEnd()
        self.requestEndFlag =  false
        print("mydata",mydata)
    }
    func configData(){

    
        Alamofire.request(getAttentionAPI(userId: userData!.id)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<ConcernsModel>.deserializeFrom(json: json.debugDescription){
                    if let data = obj.data {
                            self.concernData = data
                            self.requestEndFlag = true

                    }
                }
            }
        }
        self.waitingRequestEnd()
        self.requestEndFlag =  false
        
        Alamofire.request(getFansAPI(userId: userData!.id)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<FansModel>.deserializeFrom(json: json.debugDescription){
                    if let data = obj.data {
                        self.requestEndFlag = true
                        self.fansData = data
                    }
                }
            }
        }
        self.waitingRequestEnd()
        self.requestEndFlag =  false
        
        
        Alamofire.request(getMyBookAPI(userId:userData!.id)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<HKStory>.deserializeFrom(json: json.debugDescription){
                    self.storyData = obj.data
                    self.requestEndFlag = true
                    }
                }

        }
        self.waitingRequestEnd()
        self.requestEndFlag =  false
        
        
        if let data = concernData {
            self.headerView.concernLabel.text = "\(data.count)"
        }
        if let data = fansData {
            self.headerView.fanLabel.text = "\(data.count)"
        }
        if let datas = storyData {
            for data in datas {
                titles.append(data.bookName)
                let vc = MineStoryViewController()
                vc.datas = data
                viewControllers.append(vc)
            }
        }
        let advancedManager = LTAdvancedManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.headerView
            return headerView
        })
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self
        
        //设置悬停位置
        advancedManager.hoverY = 44
        
        /* 点击切换滚动过程动画 */
        advancedManager.isClickScrollAnimation = true
        
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        view.addSubview(advancedManager)
        
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
    
    
    func configUI(){
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = false
        }
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
//        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        //self.navigation.item.title = "王一一"
        //advancedManager.backgroundColor = .red

        self.navigation.bar.backgroundColor = .white
        self.view.backgroundColor = .white
        
        self.headerView.concernLabel.text = "\(self.userData?.concern ?? 0)"
        self.headerView.fanLabel.text = "\(self.userData?.fans ?? 3)"
        self.headerView.userSign.text = self.userData?.sgin
        self.headerView.userName.text = self.userData?.nickName
        self.headerView.storyLabel.text = "\(self.userData?.notes ?? 0)"
        let imgUrl = URL(string: self.userData!.headPic)
        self.headerView.userImg.kf.setImage(with: imgUrl)
        
        if userData?.id == getUserId()! {
            self.headerView.alterBtn.isHidden = true
        }else {
            if mydata.contains(userData!.id) {
                self.headerView.alterBtn.backgroundColor = UIColor.init(r: 146, g: 146, b: 146)
                self.headerView.alterBtn.addTarget(self, action: #selector(unAttention), for: .touchUpInside)
                self.headerView.alterBtn.setTitle("已经关注", for: .normal)
                print("包含这个分数")
            }else {
                headerView.alterBtn.addTarget(self, action: #selector(attention), for: .touchUpInside)
                print("不包含这个分数")
                self.headerView.alterBtn.setTitle("关注", for: .normal)
            }
        }
        
        advancedManagerConfig()
    
    }

    lazy var headerView:UserHeaderView = {
        let headerView = UserHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: AdaptH(320)))
        let alterBackImgTap = UITapGestureRecognizer(target: self, action: #selector(alterBackImg))
        //headerView.backgroundImageView
        headerView.backgroundImageView.addGestureRecognizer(alterBackImgTap)

        headerView.storyBtn.addTarget(self, action: #selector(story), for: .touchUpInside)
        headerView.fanBtn.addTarget(self, action: #selector(fan), for: .touchUpInside)
        headerView.concernBtn.addTarget(self, action: #selector(concern), for: .touchUpInside)
        
        return headerView
    }()
    
    


}
extension HKUserViewController: LTAdvancedScrollViewDelegate {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
//        advancedManager.advancedDidSelectIndexHandle = {
//            print("选中了 -> \($0)")
//        }

        
        
    }
    
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        print(offsetY)
        if offsetY >= 140 {
            self.navigation.bar.alpha = 1
            self.navigation.item.title = userData?.username
            self.leftBarButton.setImage(UIImage(named: "home_icon_back"), for: .normal)
            
        }
        else {
            self.navigation.bar.alpha = 0
            self.navigation.item.title = ""
            self.leftBarButton.setImage(UIImage(named: "home_icon_backwhite"), for: .normal)
        }
    }
}

// - MARK: 事件
extension HKUserViewController {
    @objc func alterBackImg() {
        print("改背景")
        
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.prepare()
        feedback.impactOccurred()
        
        let action = UIAlertController.init(title: "修改背景", message: "您是否确定要修改背景图片？", preferredStyle: .actionSheet)
        let alertY = UIAlertAction.init(title: "修改", style: .destructive) { (yes) in
            print("确定修改")
            self.imgPricker = UIImagePickerController()
            self.imgPricker.delegate = self
            self.imgPricker.allowsEditing = true
            self.imgPricker.sourceType = .photoLibrary
            
            self.imgPricker.navigationBar.barTintColor = UIColor.gray
            self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            
            self.imgPricker.navigationBar.tintColor = UIColor.white
            
            self.present(self.imgPricker, animated: true, completion: nil)
            
        }
        let alertN = UIAlertAction.init(title: "取消", style: .cancel) { (no) in
            print("取消")
        }
        
        action.addAction(alertY)
        action.addAction(alertN)
        
        self.present(action,animated: true,completion: nil)

    }
    @objc func unAttention() {
        unAttentionNet(userId: userData!.id)
        self.headerView.alterBtn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        self.headerView.alterBtn.setTitle("关注", for: .normal)
        self.headerView.alterBtn.addTarget(self, action: #selector(attention), for: .touchUpInside)
    }
    
    @objc func attention() {
        attentionNet(userId: userData!.id)
        self.headerView.alterBtn.backgroundColor = UIColor.init(r: 146, g: 146, b: 146)
        self.headerView.alterBtn.setTitle("已经关注", for: .normal)
        self.headerView.alterBtn.addTarget(self, action: #selector(unAttention), for: .touchUpInside)
    }
    @objc func story() {
        
        print("我的游记")
    }
    @objc func fan() {
        print("我的粉丝")
        if let data = concernData {
            let concernVC = FanViewController(data:data)
            self.navigationController?.pushViewController(concernVC, animated: true)
        }else {
            let concernVC = FanViewController()
            self.navigationController?.pushViewController(concernVC, animated: true)
        }
        
    }
    @objc func concern() {
        
        print("我的关注")
        if let data = concernData {
            let concernVC = ConcernViewController(data:data)
            self.navigationController?.pushViewController(concernVC, animated: true)
        }else {
            let concernVC = ConcernViewController()
            self.navigationController?.pushViewController(concernVC, animated: true)
        }
    }
    
    @objc func set() {
        print("右边按钮")
    }
    
    @objc func addStory(){
        print("添加故事簿")
    }
}
extension HKUserViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("图片选取成功")
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        let imageData1 = try! Data(contentsOf: imageURL as! URL)
        //self.img.image = img
        
       self.headerView.backgroundImageView.image = UIImage(data: imageData1)

        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HKUserViewController:AlterSginDelegate {
    func passBookName(with bookName: String) {
        self.headerView.userSign.text = bookName
        
        alterSginNet(username: userData!.username, password: userData!.password, sgin: bookName)
    }
    
    func alterSginNet(username:String,password:String,sgin:String) {
        let dic = ["username":username,"password":password,"sgin": sgin]
        
        Alamofire.request(getAlterUserInfoAPI(), method: .put, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
            }
        }
    }
}

extension HKUserViewController {
    func attentionNet(userId:String) {
        let dic = ["vId":userId]
        
        Alamofire.request(getToAttentionAPI(), method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print("关注成功")
            }
        }
    }
    func unAttentionNet(userId:String) {
        let dic = ["vId":userId]
        
        Alamofire.request(getUnAttentionAPI(), method: .delete, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print("取消关注成功")
            }
        }
    }
    
}
