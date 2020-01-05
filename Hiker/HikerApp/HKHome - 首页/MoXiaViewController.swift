//
//  MoXiaViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/24.
//  Copyright © 2019 张驰. All rights reserved.
//

//
//  MoXiaViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/23.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import MJRefresh
import LTScrollView
import SnapKit
import Alamofire
import HandyJSON
import SwiftyJSON
import ProgressHUD

private let HKHomeSearchViewID = "HomeSearchView"
private let HKRecommendCityID = "RecommendCityView"
private let HKStoryID = "StoryView"
private let HeaderViewID = "HomeHeaderReusableView"

class MoXiaViewController: UIViewController {
       
    var page = 1
    private var data = [NotesModel]()
    private var word = ""

    convenience init(word:String) {
        self.init()
        self.word = word
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configNav()
        reftreshData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configData()
    }
    
    func configNav(){
    }
    
    func configUI(){
        view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        view.backgroundColor = backColor
        glt_scrollView = collectionView
        glt_scrollView?.showsVerticalScrollIndicator = false
    }
    
    /// 网络加载数据
    func configData() {
        
        Alamofire.request(getSearchAPI(word: self.word)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let obj = JSONDeserializer<HomeModel>.deserializeFrom(json: json.debugDescription){
                    for data in obj.data! {
                        self.data.append(data)
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
          func reftreshData()  {
             
             collectionView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
                     print("上拉加载更多数据")
     //                self!.page += 1
     //                self?.configData(page: self!.page)
                     self?.collectionView.mj_footer.endRefreshing()
             }
             collectionView.mj_header = MJRefreshNormalHeader {[weak self] in

                     print("下拉刷新 --- 1")
     //                self!.data.removeAll()
     //                self!.configData(page: 1)
     //                self!.collectionView.reloadData()
                 self?.collectionView.mj_header.endRefreshing()
             }
         }
}

extension MoXiaViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let identifier = "story\(indexPath.section)\(indexPath.row)"
            self.collectionView.register(StoryView.self, forCellWithReuseIdentifier: identifier)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StoryView
            
            config(cell, with: data[indexPath.row])
            return cell
        
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
            return 30

    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           return CGSize(width: AdaptW(374), height: 350)
    }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID, for: indexPath) as? HomeHeaderReusableView else {
            return UICollectionReusableView()
        }
       headerView.titleLabel.text = "有\(data.count)个关于末夏体验的故事。"
        headerView.titleLabel.textColor = UIColor.init(r: 146, g: 146, b: 146)
        headerView.titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: 414, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let model = data[indexPath.row]
              let vc = StoryViewController(model: model)
              self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK - 配置cell

extension MoXiaViewController {
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
        let se = Set(locations)
        locations = Array(se)
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
            
            let datas = data[(indexPath?.row)!]
            var locations = [String]()
            for note in datas.noteParas! {
                locations.append(note.place)
            }
            let vc = SearchContentViewController(word: locations[0])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        @objc func user(_ sender:UIButton){
            let btn = sender
            let cell = btn.superView(of: StoryView.self)!
            let indexPath = collectionView.indexPath(for: cell)
            
            let model = data[(indexPath?.row)!].user!

            let userVC = HKUserViewController(data: model)
            self.navigationController?.pushViewController(userVC, animated: true)
        }

    
    
}
extension MoXiaViewController {
    @objc func collected(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)
        
        if data[(indexPath?.row)!].collected {
            cell.favBtn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
            data[(indexPath?.row)!].collected = false
            unCollecteNet(noteId: data[(indexPath?.row)!].id)
        }else {
            cell.favBtn.setImage(UIImage(named: "home_story_fav"), for: .normal)
            data[(indexPath?.row)!].collected = true
            collecteNet(noteId: data[(indexPath?.row)!].id)
            
        }

    }
    
    @objc func fav(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: StoryView.self)!
        let indexPath = collectionView.indexPath(for: cell)
        
        if data[(indexPath?.row)!].like {
            cell.favIcon.setImage(UIImage(named: "home_stroy_unloveblack"), for: .normal)
            cell.favLabel.text = "\(Int(cell.favLabel.text!)! - 1)"
            data[(indexPath?.row)!].like = false
            favNet(noteId: data[(indexPath?.row)!].id)
        }else {
            cell.favIcon.setImage(UIImage(named: "home_story_lovered"), for: .normal)
            cell.favLabel.text = "\(Int(cell.favLabel.text!)! + 1)"
            data[(indexPath?.row)!].like = true
            favNet(noteId: data[(indexPath?.row)!].id)
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

