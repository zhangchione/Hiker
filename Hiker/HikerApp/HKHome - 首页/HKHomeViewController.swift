//
//  HKHomeViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import HandyJSON
import SwiftyJSON
import ProgressHUD
import MJRefresh

class HKHomeViewController: UIViewController {
    
    
    let storyAPI = "http://120.77.151.36:8080/note/1?token=" + getToken()!
    
    var data = [1,2,3,4,5,1,2,3,4,5]
    
    // MARK - 右边功能按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
       // button.frame = CGRect(x:10, y:100, width:40, height: 40)
        button.addTarget(self, action: #selector(tip), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "home_icon_tip"), for: .normal)
        //button.backgroundColor = UIColor.red
        return button
    }()
    
    
    private let HKHomeSearchViewID = "HomeSearchView"
    private let HKRecommendCityID = "RecommendCityView"
    private let HKStoryID = "StoryView"
    private let HeaderViewID = "HomeHeaderReusableView"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = backColor
        
        // 注册头部视图
        collection.register(HomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID)
        
        collection.register(HomeSearchView.self, forCellWithReuseIdentifier: HKHomeSearchViewID)
        collection.register(RecommendCityView.self, forCellWithReuseIdentifier: HKRecommendCityID)
        collection.register(StoryView.self, forCellWithReuseIdentifier: HKStoryID)
        collection.showsHorizontalScrollIndicator  = false
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    var notesDatas = [NotesModel]()
    
    func configLocationJsonData(){
        let path = Bundle.main.path(forResource: "HKHomejson", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        
        let json = JSON(jsonData!)
        
        if let obj = JSONDeserializer<HomeModel>.deserializeFrom(json: json.description) {
            
            for data in obj.data! {
                self.notesDatas.append(data)
            }
            self.collectionView.reloadData()
        }
    }
    
    func refresh(){
        collectionView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("上拉加载更多数据")
                self?.configLocationJsonData()
                self?.collectionView.mj_footer.endRefreshing()
            })
        }
        collectionView.mj_header = MJRefreshNormalHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("下拉刷新 --- 1")
                self?.collectionView.mj_header.endRefreshing()
            })
        }
    }
    
    func configData() {
        Alamofire.request(storyAPI).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                    let json = JSON(value)
                if let obj = JSONDeserializer<HomeModel>.deserializeFrom(json: json.debugDescription){
                    print(obj)
                    for data in obj.data! {
                        self.notesDatas.append(data)
                    }
                    print(obj.data!.count)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocationJsonData()
        configUI()
        configNav()
        refresh()

    }
    
    func configUI(){
        view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
         view.backgroundColor = backColor
        
    }

    func configNav(){
        if #available(iOS 11.0, *) {

            self.navigation.bar.prefersLargeTitles = true
            
        }
        
        navigation.bar.automaticallyAdjustsPosition = false
        
        self.navigation.item.title = "发现"
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.addSubview(rightBarButton)
        rightBarButton.snp.makeConstraints { (make) in
            make.right.equalTo(navigation.bar.snp.right).offset(-25)
            make.bottom.equalTo(navigation.bar.snp.bottom).offset(-20)
            make.width.height.equalTo(30)
        }
    }

    @objc func add() {
        print("中间按钮")
    }
    @objc func tip(){
          configLocationJsonData()
//        let tipsVC = TipsViewController()
//        navigationController?.pushViewController(tipsVC, animated: true)
    }
}


extension HKHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY < -94.0 {
            rightBarButton.snp.remakeConstraints { (make) in
                make.right.equalTo(navigation.bar.snp.right).offset(-25)
                make.bottom.equalTo(navigation.bar.snp.bottom).offset(-20)
                make.width.height.equalTo(30)
            }
        } else {
            rightBarButton.snp.remakeConstraints { (make) in
                make.right.equalTo(navigation.bar.snp.right).offset(-25)
                make.bottom.equalTo(navigation.bar.snp.bottom).offset(-10)
                make.width.height.equalTo(30)
            }
        }
    
    }

}
extension HKHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section <= 1 {
            return 1
        }else {
            return notesDatas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HKHomeSearchViewID, for: indexPath) as! HomeSearchView
        return cell
        }
        else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HKRecommendCityID, for: indexPath) as! RecommendCityView
            return cell
        }else {
            let identifier = "story\(indexPath.section)\(indexPath.row)"
            self.collectionView.register(StoryView.self, forCellWithReuseIdentifier: identifier)

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StoryView
            cell.favBtn.addTarget(self, action: #selector(fav(_:)), for: .touchUpInside)
            //cell.photoCell.imgData = data[indexPath.row]
            config(cell, with: notesDatas[indexPath.row])
            return cell
        }
    }
    
    @objc func fav(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)

        if data[(indexPath?.row)!] == 1 {
            cell.favBtn.setImage(UIImage(named: "home_story_fav"), for: .normal)
            cell.favLabel.text = "\(Int(cell.favLabel.text!)! + 1)"
            data[(indexPath?.row)!] = 0
        }else {
            cell.favBtn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
            cell.favLabel.text = "\(Int(cell.favLabel.text!)! - 1)"
            data[(indexPath?.row)!] = 1
            
        }
        //sum = sum + (label.text! as NSString).integerValue
       // self.title = "总数：\(sum)"
        
    }
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return  UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        }
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 30
        }
        return 0
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 374, height: 50)
        }else if indexPath.section == 1{
            return CGSize(width: 414, height: 220)
        }else {
            return CGSize(width: 374, height: 350)
        }
    }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID, for: indexPath) as? HomeHeaderReusableView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 2{
            headerView.titleLabel.text = "故事"
        }
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
        return CGSize(width: 414, height: 30)
        }
        if section == 2 {
            return CGSize(width: 414, height: 30)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let searchVC = SearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else {
        var model = NotesModel()
        model.title = "魔都上海两日"
        let vc = StoryViewController(model: model)
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension HKHomeViewController {
    func config(_ cell:StoryView,with data:NotesModel) {
        cell.userName.text = data.user?.username
        cell.title.text = data.title
        var locations = ""
        if let locas = data.locations {
            locations = locas.joined(separator: "、")
        }
        cell.trackLocation.text = "#" + locations
        cell.userIcon.image = UIImage(named: data.user!.headPic)
        cell.favLabel.text = "\(data.likes)"
        cell.time.text = data.time
        cell.liked = data.like
        if data.like {
            cell.favIcon.image = UIImage(named: "home_story_love")
        }else {
            cell.favIcon.image = UIImage(named: "home_stroy_unlove")
        }
        cell.photoCell.imgDatas = data.pics
        //cell.userIcon.image = UIImage(named: "1")
    }
}
