//
//  HKMineViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
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

class HKMineViewController: UIViewController {
    
    
    var mineData:UserModel?
    var storyData:[StoryModel]?
    var concernData:[User]?
    var fansData: [User]?
    
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
        layout.showsHorizontalScrollIndicator = false
        layout.isHiddenPageBottomLine = true
        layout.isShowBounces = true
        layout.pageBottomLineHeight = 0
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        print(statusBarH)
        let Y: CGFloat = statusBarH + 88
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y ) : view.bounds.height - Y + 44
        return CGRect(x: 0, y: statusBarH, width: view.bounds.width, height: H)
    }

    // MARK - 右边功能按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
         button.frame = CGRect(x:10, y:0, width:40, height: 40)
        button.addTarget(self, action: #selector(set), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "mine_icon_set"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            configMineData()
            configFansData()
    }
    
    func configMineData() {
        Alamofire.request(getMineAPI()).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<MineModel>.deserializeFrom(json: json.debugDescription){
                    self.mineData = obj.data
                    //self.headerView.concernLabel.text = "\(self.mineData?.concern ?? 0)"
                    //self.headerView.fanLabel.text = "\(self.mineData?.fans ?? 3)"
                    self.headerView.userSign.text = self.mineData?.sgin
                    self.headerView.userName.text = self.mineData?.nickName
                    self.headerView.storyLabel.text = "\(self.mineData?.notes ?? 0)"
                    let imgUrl = URL(string: self.mineData!.headPic)
                    self.headerView.userImg.kf.setImage(with: imgUrl)
                    let backImgUrl = URL(string:self.mineData!.bgPic)
                    self.headerView.backgroundImageView.kf.setImage(with: backImgUrl)
                    
                }
            }
        }
    }
    
    func configFansData() {
         Alamofire.request(getAttentionAPI(userId: getUserId()!)).responseJSON { (response) in
             guard response.result.isSuccess else {
                 ProgressHUD.showError("网络请求错误"); return
             }
             if let value = response.result.value {
                 let json = JSON(value)
                 if let obj = JSONDeserializer<ConcernsModel>.deserializeFrom(json: json.debugDescription){
                     if let data = obj.data {
                             self.concernData = data
                             self.headerView.concernLabel.text = "\(data.count)"
                            // self.requestEndFlag = true
                         print(data,2)
                     }
                 }
             }
         }

         Alamofire.request(getFansAPI(userId: getUserId()!)).responseJSON { (response) in
             guard response.result.isSuccess else {
                 ProgressHUD.showError("网络请求错误"); return
             }
             if let value = response.result.value {
                 let json = JSON(value)
                 if let obj = JSONDeserializer<FansModel>.deserializeFrom(json: json.debugDescription){
                     if let data = obj.data {
                        // self.requestEndFlag = true
                         self.fansData = data
                         self.headerView.fanLabel.text = "\(data.count)"
                         print(data,1)
                     }
                 }
             }
         }
    }
    func configData(){
        var stroyData = [NotesModel]()
        Alamofire.request(getMyBookAPI(userId: getUserId()!)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<HKStory>.deserializeFrom(json: json.debugDescription){
                    self.storyData = obj.data
                    //self.requestEndFlag = true
                    }
                if let datas = self.storyData {
                    for data in datas {
                        self.titles.append(data.bookName)
                        let vc = MineStoryViewController()
                        vc.datas = data.story
                        self.viewControllers.append(vc)
                        
                        for s in data.story! {
                            stroyData.append(s)
                        }
                      
                    }
                }
                self.titles.insert("全部", at: 0)
                let allVC = MineStoryViewController()
                allVC.datas = stroyData
                self.viewControllers.insert(allVC, at: 0)
                
                let advancedManager = LTAdvancedManager(frame: self.managerReact(), viewControllers: self.viewControllers, titles: self.titles, currentViewController: self, layout: self.layout, headerViewHandle: {[weak self] in
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
                self.view.addSubview(advancedManager)
                
                }

        }

//        self.waitingRequestEnd()
//        self.requestEndFlag =  false
        

        
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
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        //self.navigation.item.title = "王一一"
        //advancedManager.backgroundColor = .red

        self.navigation.bar.backgroundColor = .white
        self.view.backgroundColor = .white
        advancedManagerConfig()
    
    }

    lazy var headerView:MineHeaderView = {
        let headerView = MineHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: AdaptH(320)))
        let alterBackImgTap = UITapGestureRecognizer(target: self, action: #selector(alterBackImg))
        //headerView.backgroundImageView
        headerView.backgroundImageView.addGestureRecognizer(alterBackImgTap)
        headerView.alterBtn.addTarget(self, action: #selector(alterUserSign), for: .touchUpInside)
        headerView.storyBtn.addTarget(self, action: #selector(story), for: .touchUpInside)
        headerView.fanBtn.addTarget(self, action: #selector(fan), for: .touchUpInside)
        headerView.concernBtn.addTarget(self, action: #selector(concern), for: .touchUpInside)
        
        return headerView
    }()
    
    


}
extension HKMineViewController: LTAdvancedScrollViewDelegate {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
//        advancedManager.advancedDidSelectIndexHandle = {
//            print("选中了 -> \($0)")
//        }

        
        
    }
    
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        if offsetY >= 140 {
            self.navigation.bar.alpha = 1
            self.navigation.item.title = mineData?.nickName
            self.rightBarButton.setImage(UIImage(named: "mine_icon_setblack"), for: .normal)
        }
        else {
            self.navigation.bar.alpha = 0
            self.navigation.item.title = ""
            self.rightBarButton.setImage(UIImage(named: "mine_icon_set"), for: .normal)
        }
    }
}

// - MARK: 事件
extension HKMineViewController {
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

    @objc func alterUserSign() {
        UIApplication.shared.keyWindow?.addSubview(self.alterSginView)
        self.alterSginView.showAddView()
        print("改签名")
    }
    @objc func story() {
        
        print("我的游记")
    }
    @objc func fan() {
        print("我的粉丝")
        if let data = fansData {
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
        let setVC = SetViewController()
        setVC.userData = mineData
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    
    @objc func addStory(){
        print("添加故事簿")
    }
}
extension HKMineViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("图片选取成功")
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        let imageData1 = try! Data(contentsOf: imageURL as! URL)
        let a = imageURL as! URL
        print(a)
        let imgUrl = (imageURL as! URL).path

       self.headerView.backgroundImageView.image = UIImage(data: imageData1)
        // 上传背景图
        let code =  uploadPic(imageURL:imgUrl)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HKMineViewController:AlterSginDelegate {
    func passBookName(with bookName: String) {
        self.headerView.userSign.text = bookName
        
        alterSginNet(username: mineData!.username, password: mineData!.password, sgin: bookName)
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
    
    func alterBackImgNet(username:String,password:String,backImg:String) {
            let dic = ["username":username,"password":password,"bgPic": backImg]
            
            Alamofire.request(getAlterUserInfoAPI(), method: .put, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                guard response.result.isSuccess else {
                    ProgressHUD.showError("网络请求错误"); return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    print("头像修改成功")
                }
            }
        }
        
        func uploadPic(imageURL:String) -> String{

            let image = UIImage(contentsOfFile: imageURL)
            let imageData = UIImage.jpegData(image!)(compressionQuality: 1)
            var imgUrl = ""
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData!, withName: "file", fileName: "2.jpg",mimeType: "image/jpeg")
                print("图片准备上传")

            }, to: getImageAPI()) { (encodingResult) in
                switch encodingResult {
                case .success(let upload,_,_):
                    upload.responseString{ response in
                        if let data = response.data {
                            let json = JSON(data)
                            imgUrl = json["data"].stringValue
                            print(imgUrl)
                            self.alterBackImgNet(username: self.mineData!.username, password: self.mineData!.password,backImg: imgUrl)
    //                            self.requestEndFlag = true
                        }
                        //获取上传进度
                        upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                            print("图片上传进度: \(progress.fractionCompleted)")
                        }
                    }
                case .failure(_):
                    print("上传失败")
                }

            }
    //        waitingRequestEnd()
    //        self.requestEndFlag = false
            print("图片上传完成")
            return imgUrl
        }
}
