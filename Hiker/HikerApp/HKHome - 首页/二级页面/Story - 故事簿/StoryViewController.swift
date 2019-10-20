//
//  StoryViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

import  Alamofire
import  SwiftyJSON
import  ProgressHUD

class StoryViewController: StoryBaseViewController {

    
    private var notesData = NotesModel()
    
    let storyBannerView: StoryBannerView
    let storyBannerViewModel:StoryBannerViewModel
    let bannerHeight: CGFloat = 86+44+UIScreen().titleY
    
    init(model:NotesModel) {
        storyBannerViewModel = StoryBannerViewModel(with: model)
        storyBannerView = StoryBannerView(with: storyBannerViewModel)
        super.init()
        self.paras = model.noteParas
        self.notesData = model
        storyBannerViewModel.userCallBack = { [unowned self] in
            print("点击用户")
            let userVC = HKUserViewController(data: model.user!)
            self.navigationController?.pushViewController(userVC, animated: true)
        }
        storyBannerViewModel.backCallBack = { [unowned self] in
            print("收藏")
        }
        
        storyBannerView.viewModel = storyBannerViewModel
        setupBanner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBanner() {
        tableView.contentInset =
            UIEdgeInsets(top: bannerHeight, left: 0, bottom: 0, right: 0)
        self.tableView.addSubview(storyBannerView)
    }
    
    //导航栏背景视图
    var barImageView: UIView?
    var imageView: UIImageView! // 图片视图
    let imageViewHeight: CGFloat = 300 // 图片默认高度

    
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

       configNav()
       setUI()
    }
    func configNav(){
        view.backgroundColor = .white
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = true
            self.navigation.item.largeTitleDisplayMode = .automatic
        }
        
       
    }
    

    
    func setUI(){
        
        //获取导航栏背景视图
        self.barImageView = self.navigationController?.navigationBar.subviews.first
        //修改导航栏背景色
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .white
    
        if  self.notesData.like {
            self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_fav"), for: .normal)
        }else {
            self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_unfav"), for: .normal)
        }
        self.loveBtn.addTarget(self, action: #selector(fav(_:)), for: .touchUpInside)
        
        if  self.notesData.collected {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_collected"), for: .normal)
        }else {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_uncollected"), for: .normal)
        }
        self.hiddenBtn.addTarget(self, action: #selector(collected(_:)), for: .touchUpInside)
        self.commentBtn.addTarget(self, action: #selector(comment), for: .touchUpInside)
    }
    
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    

}

// 收藏 点赞 评论 按钮事件
extension StoryViewController {
    
    @objc func comment(){
        let vc = CommentViewController(data: notesData.comments!,noteId:notesData.id)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func collected(_ sender:UIButton){
        
        if notesData.collected {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_uncollected"), for: .normal)
            notesData.collected = false
            unCollecteNet(noteId: notesData.id)
        }else {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_collected"), for: .normal)
            notesData.collected = true
            collecteNet(noteId: notesData.id)
        }
        
        
    }
    
    @objc func fav(_ sender:UIButton){

        if notesData.like {
            self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_unfav"), for: .normal)
            notesData.like = false
            favNet(noteId: notesData.id)
        }else {
             self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_fav"), for: .normal)
            notesData.like = true
            favNet(noteId: notesData.id)
            
        }
        
        
        
    }
    
    func favNet(noteId:Int) {
        
        Alamofire.request(getFavAPI(noteId: noteId)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                    print(json)
            }
        }
    }
    
    func collecteNet(noteId:Int) {

        let dic = ["userId":getUserId()!,"noteId":noteId] as [String : Any]
        
        Alamofire.request(getCollectedAPI(noteId: noteId), method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("收藏网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print(json,1)
            }
        }
    }
    
    func unCollecteNet(noteId:Int) {
        let dic = ["userId":getUserId()!,"noteId":noteId] as [String : Any]
        Alamofire.request(getUnCollectedAPI(noteId: noteId), method: .delete, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                ProgressHUD.showError("收藏网络请求错误"); return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
            }
        }
    
    }
    
}




extension StoryViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let offset = bannerHeight + scrollView.contentOffset.y
        if offset < 0 {
            storyBannerView.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: UIScreen.main.bounds.width, height: abs(scrollView.contentOffset.y))
        } else {
            storyBannerView.frame = CGRect(x: 0, y: -bannerHeight, width: UIScreen.main.bounds.width, height: bannerHeight)
        }
        
//        let offset = scrollView.contentOffset.y
//        if offset <= 0 {
//            self.imageView.frame = CGRect(x: 0, y: offset, width: TKWidth,
//                                          height: imageViewHeight - offset)
//        }
 
        if offset > 90 {
            self.navigation.bar.alpha = 1
            navigation.item.title = notesData.title
            leftBarButton.setImage(UIImage(named: "home_icon_back"), for: .normal)
        }else {
            self.navigation.bar.alpha = 0
            navigation.item.title = ""
            leftBarButton.setImage(UIImage(named: "home_icon_backwhite"), for: .normal)
        }

    }
}
