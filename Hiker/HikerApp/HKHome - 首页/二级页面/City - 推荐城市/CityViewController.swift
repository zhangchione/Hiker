//
//  ViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/26.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class CityViewController: SubClassBaseViewController {

    private var data:CityModel?
    convenience init(data:CityModel) {
        self.init()
        self.data = data
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configNav(){
       self.navigation.item.title =  "“" + data!.cityname + "”"
       self.navigation.bar.backgroundColor = backColor
    }
    func configUI(){
        view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        view.backgroundColor = backColor
    }
    

}
extension CityViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.story?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let identifier = "story\(indexPath.section)\(indexPath.row)"
            self.collectionView.register(StoryView.self, forCellWithReuseIdentifier: identifier)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StoryView
            let storyData = data?.story![indexPath.row]
            //cell.favBtn.addTarget(self, action: #selector(fav(_:)), for: .touchUpInside)
            //cell.photoCell.imgData = data[indexPath.row]
            config(cell, with: storyData!)
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

            return CGSize(width: 374, height: 350)
    }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewID, for: indexPath) as? HomeHeaderReusableView else {
            return UICollectionReusableView()
        }
        let cityname = data?.cityname
        headerView.titleLabel.text = "有\((data?.story?.count)!)个关于“\(cityname ?? "")”的故事。"
        headerView.titleLabel.textColor = UIColor.init(r: 146, g: 146, b: 146)
        headerView.titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: 414, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyData = data?.story![indexPath.row]
            let vc = StoryViewController(model: storyData!)
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK - 配置cell

extension CityViewController {
    func config(_ cell:StoryView,with data:NotesModel) {
        let pics = data.noteParas![0].pics.components(separatedBy: ",")
        cell.photoCell.imgDatas = pics
        let imgUrl = URL(string: data.user!.headPic)
        cell.userIcon.kf.setImage(with: imgUrl)
        cell.userName.text = data.user?.username
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
            cell.favIcon.setImage(UIImage(named: "home_story_fav"), for: .normal)
        }else {
            cell.favIcon.setImage(UIImage(named: "home_story_unfav"), for: .normal)
        }
        //cell.favIcon.addTarget(self, action: #selector(fav(_:)), for: .touchUpInside)
        if data.collected {
            cell.favBtn.setImage(UIImage(named: "home_story_fav"), for: .normal)
        }else {
            cell.favBtn.setImage(UIImage(named: "home_story_unfav"), for: .normal)
        }
        //cell.favBtn.addTarget(self, action: #selector(collected(_:)), for: .touchUpInside)
    }
}

extension CityViewController  {
    
}
