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
import Kingfisher


private let HKHomeSearchViewID = "HomeSearchView"
private let HKRecommendCityID = "RecommendCityView"
private let HKStoryID = "StoryView"
private let HeaderViewID = "HomeHeaderReusableView"


class HKHomeViewController: UIViewController {
    
    var page = 1
    
    var data = [1,2,3,4,5,1,2,3,4,5]
    
    var notesDatas = [NotesModel]()
    var cityDatas = [CityModel]()
    
    var myBookData = [StoryModel]()
    
    var cityData = [City]()
    /// 右边功能按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
       // button.frame = CGRect(x:10, y:100, width:40, height: 40)
        button.addTarget(self, action: #selector(tip), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "home_icon_tip"), for: .normal)
        //button.backgroundColor = UIColor.red
        return button
    }()
    
    /// 主界面View
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = backColor
        
        // 注册头部视图
        collection.register(HomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID)
        
        // 注册Cell
        collection.register(HomeSearchView.self, forCellWithReuseIdentifier: HKHomeSearchViewID)
        collection.register(RecommendCityView.self, forCellWithReuseIdentifier: HKRecommendCityID)
        collection.register(StoryView.self, forCellWithReuseIdentifier: HKStoryID)
        collection.showsHorizontalScrollIndicator  = false
        collection.showsVerticalScrollIndicator = false
//        collection.uHead = URefreshHeader{ [weak self] in self?.refresh() }
//        collection.mj_header = MJRefreshNormalHeader{[weak self] in
//            self?.collectionView.mj_header.endRefreshing()
//                }
        collection.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                self!.page += 1
                self?.configData(page: self!.page)
                self?.collectionView.mj_footer.endRefreshing()
            })
        }
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configHKStoryData()
        configLocationJsonData()
        configUI()
        configNav()

    }

    override func viewWillAppear(_ animated: Bool) {
        configHKStoryData()
        self.notesDatas.removeAll()
        self.page = 1
        self.configData(page: self.page)
        self.collectionView.reloadData()

    }

    func configHKStoryData(){
        self.myBookData.removeAll()
        
        UserDefaults.standard.removeObject(forKey: "bookname")
        UserDefaults.standard.removeObject(forKey: "bookid")
        UserDefaults.standard.removeObject(forKey: "booknum")
  
        Alamofire.request(getMyBookAPI(userId: getUserId()!)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<HKStory>.deserializeFrom(json: json.debugDescription){
                    for data in obj.data! {
                        self.myBookData.append(data)
                    }
                    var bookname = [String]()
                    var bookid = [Int]()
                    var booknum = [Int]()
                    for data in self.myBookData {
                        bookname.append(data.bookName)
                        bookid.append(data.id)
                        booknum.append(data.story!.count)
                    }
                    print("bookname",bookname)
                    saveBookId(bookname: bookid)
                    saveBookName(bookname: bookname)
                    saveBookNum(bookname: booknum)
                }
            }
        }
    }
    
    @objc func tip(){

        let tipsVC = TipsViewController()
        navigationController?.pushViewController(tipsVC, animated: true)
    }
}

// MARK - 配置UI

extension HKHomeViewController {
    
    func configUI(){
        view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.equalTo(TKWidth)
            make.height.equalTo(TKHeight)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
        }
        view.backgroundColor = backColor
        print("d11111断电")
    }
    
    func configNav(){
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = true
            self.navigation.item.largeTitleDisplayMode = .automatic
        }
        //navigation.bar.automaticallyAdjustsPosition = false
        self.navigation.item.title = "发现"
        self.navigation.bar.alpha = 1
        self.navigation.bar.isShadowHidden = true
        if TKHeight >= 812 {
                self.navigation.bar.frame.origin.y = 44
        }else {
                self.navigation.bar.frame.origin.y = 20
        }

        self.navigation.bar.addSubview(rightBarButton)
        //self.navigation.bar.isHidden = true
        rightBarButton.snp.makeConstraints { (make) in
            make.right.equalTo(navigation.bar.snp.right).offset(-25)
            make.bottom.equalTo(navigation.bar.snp.bottom).offset(-20)
            make.width.height.equalTo(30)
        }
    }
}

// MARK - 加载数据

extension HKHomeViewController {
    
    /// 加载本地数据json
    func configLocationJsonData(){
 
        
        let model = City(title: "上海", img: "img1")
        let model2 = City(title: "株洲", img: "img2")
        let model3 = City(title: "长沙", img: "img3")
        let model4 = City(title: "杭州", img: "img4")
        
        self.cityData.append(model)
        self.cityData.append(model2)
        self.cityData.append(model3)
        self.cityData.append(model4)
        

        
        self.collectionView.reloadData()
    }

    /// 网络加载数据
    func configData(page:Int) {
        
        Alamofire.request(getHomeAPI(page: page)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<HomeModel>.deserializeFrom(json: json.debugDescription){
                    for data in obj.data! {
                        self.notesDatas.append(data)
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
//    func getUserInfo(){
//        Alamofire.request(getUserInfoAPI()).responseJSON { (response) in
//            guard response.result.isSuccess else {
//                ProgressHUD.showError("网络请求错误"); return
//            }
//            if let value = response.result.value {
//                let json = JSON(value)
//                saveUserId(userId: json["data"]["id"].stringValue)
//                saveHeadPic(headPic: json["data"]["headPic"].stringValue)
//                saveNickName(nickName: json["data"]["nickName"].stringValue)
//                print("userid 存储成功为：",getUserId())
//                print(getHeadPic())
//                print(getNickName())
//            }
//        }
//    }
}

// MARK - ScrollView滚动代理

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

// MARK - 数据源

extension HKHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
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
            cell.datas = self.cityData
            cell.delegate = self
            return cell
        }else {
            let identifier = "story\(indexPath.section)\(indexPath.row)"
            self.collectionView.register(StoryView.self, forCellWithReuseIdentifier: identifier)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StoryView

            //cell.photoCell.imgData = data[indexPath.row]
            config(cell, with: notesDatas[indexPath.row])
            return cell
        }
    }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID, for: indexPath) as? HomeHeaderReusableView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 2{
            headerView.titleLabel.text = "故事"
        }else {
            headerView.titleLabel.text = "推荐城市"
        }
        return headerView
    }
}

// MARK - 代理

extension HKHomeViewController:  UICollectionViewDelegate {
    
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
            return CGSize(width: AdaptW(374), height: AdaptH(50))
        }else if indexPath.section == 1{
            return CGSize(width: TKWidth, height: 220)
        }else {
            return CGSize(width: AdaptW(374), height: 350)
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
        return CGSize(width: TKWidth, height: 30)
        }
        if section == 2 {
            return CGSize(width: TKWidth, height: 30)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let searchVC = SearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else {
            let model = notesDatas[indexPath.row]
            let vc = StoryViewController(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK - @objc 方法

extension HKHomeViewController {
    
    @objc func collected(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)
        
        if notesDatas[(indexPath?.row)!].collected {
            cell.favBtn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
            notesDatas[(indexPath?.row)!].collected = false
            unCollecteNet(noteId: notesDatas[(indexPath?.row)!].id)
        }else {
            cell.favBtn.setImage(UIImage(named: "home_story_fav"), for: .normal)
            notesDatas[(indexPath?.row)!].collected = true
            collecteNet(noteId: notesDatas[(indexPath?.row)!].id)
            
        }

    }
    
    @objc func fav(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)
        
        if notesDatas[(indexPath?.row)!].like {
            cell.favIcon.setImage(UIImage(named: "home_stroy_unloveblack"), for: .normal)
            cell.favLabel.text = "\(Int(cell.favLabel.text!)! - 1)"
            notesDatas[(indexPath?.row)!].like = false
            favNet(noteId: notesDatas[(indexPath?.row)!].id)
        }else {
            cell.favIcon.setImage(UIImage(named: "home_story_lovered"), for: .normal)
            cell.favLabel.text = "\(Int(cell.favLabel.text!)! + 1)"
            notesDatas[(indexPath?.row)!].like = true
            favNet(noteId: notesDatas[(indexPath?.row)!].id)
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

// MARK - 配置cell

extension HKHomeViewController {
    func config(_ cell:StoryView,with data:NotesModel) {
        
        let pics = data.noteParas![0].pics.components(separatedBy: ",")
        cell.photoCell.imgDatas = pics
        let imgUrl = URL(string: data.user!.headPic)
        cell.userIcon.kf.setImage(with: imgUrl)
        cell.userName.text = data.user?.nickName
        var locations = [String]()
        for note in data.noteParas! {
            locations.append(note.place)
        }
        let place = locations.joined(separator: "、")
        cell.trackLocation.text = "#" + place
 
        
        cell.title.text = data.title
        cell.time.text = data.noteParas![0].date
        cell.favLabel.text = "\(data.likes)"
        if data.like {
            cell.favIcon.setImage(UIImage(named: "home_story_lovered"), for: .normal)
        }else {
            cell.favIcon.setImage(UIImage(named: "home_stroy_unloveblack"), for: .normal)
        }
        cell.favIcon.addTarget(self, action: #selector(fav(_:)), for: .touchUpInside)
        if data.collected {
            cell.favBtn.setImage(UIImage(named: "home_story_fav"), for: .normal)
        }else {
            cell.favBtn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
        }
        cell.favBtn.addTarget(self, action: #selector(collected(_:)), for: .touchUpInside)
        cell.trackBtn.addTarget(self, action: #selector(self.city(_:)), for:    .touchUpInside)
         cell.userBtn.addTarget(self, action: #selector(self.user(_:)), for:    .touchUpInside)
    }
    
    @objc func city(_ sender:UIButton){
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)
        
        let data = notesDatas[(indexPath?.row)!]
        var locations = [String]()
        for note in data.noteParas! {
            locations.append(note.place)
        }
        let vc = CityViewController(words: locations)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func user(_ sender:UIButton){
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)
        
        let model = notesDatas[(indexPath?.row)!]

        let userVC = HKUserViewController(data: model.user!)
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
}

// MARK -  点击代理事件

extension HKHomeViewController: CityDelegate {
    func cityClick(with data: String) {
        let vc = SearchContentViewController(word: data)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
