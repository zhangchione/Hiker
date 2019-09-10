//
//  StoryViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class StoryViewController: StoryBaseViewController {

    let storyBannerView: StoryBannerView
    let storyBannerViewModel:StoryBannerViewModel
    let bannerHeight: CGFloat = 86+44+UIScreen().titleY
    
    init(model:StoryBannerModel) {
        storyBannerViewModel = StoryBannerViewModel(with: model)
        storyBannerView = StoryBannerView(with: storyBannerViewModel)
        super.init()
        
        storyBannerViewModel.userCallBack = { [weak self] in
            print("点击用户")
        }
        storyBannerViewModel.backCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
    lazy var tableView: UITableView = {
        //创建表视图
        let tableView = UITableView(frame: CGRect(x: 0, y: 0,
                                                   width: TKWidth, height: CGFloat(rowNumber) * rowHeight), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(rowHeight)
        //self.tableView.isScrollEnabled = false
        //创建一个重用的单元格
        tableView.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "SwiftCell")
        return tableView
    }()
    let rowNumber = 6 // 表格数据条目数
    let rowHeight: CGFloat = 200 // 表格行高
    
    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "home_icon_back"), for: .normal)
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
    }
    

    func setUI(){
        
        //获取导航栏背景视图
        self.barImageView = self.navigationController?.navigationBar.subviews.first
        //修改导航栏背景色
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .white
        
        

        
       
        //scrollView.addSubview(self.tableView!)
        view.addSubview(self.tableView)
        
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension StoryViewController: UIScrollViewDelegate {
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
        
        // 导航栏背景透明度改变
        var delta =  offset / (imageViewHeight - 64)
        delta = CGFloat.maximum(delta, 0)
        self.barImageView?.alpha = CGFloat.minimum(delta, 1)
        
        // 根据偏移量决定是否显示导航栏标题（上方图片快完全移出时才显示）
        self.title =  delta > 0.9 ? "上海之旅" : ""
    }
}
extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    //在本例中，有1个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return rowNumber
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identify, for: indexPath)
            cell.textLabel?.text = "数据条目：\(indexPath.row + 1)"
            return cell
    }
}
