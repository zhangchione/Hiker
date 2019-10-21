//
//  HKHomeHeaderView.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/21.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

// 图片按钮点击代理方法
protocol HomeHeaderDelegate:NSObjectProtocol {
    func cityClicks(with data:String)
    
    func searchClicks()
}


class HKHomeHeaderView: UIView {
    
        weak var delegate: HomeHeaderDelegate?
    
    var notesDatas = [NotesModel]()
    var cityDatas = [CityModel]()
    
    var myBookData = [StoryModel]()
    
    var cityData = [City]()
    
    private let HKHomeSearchViewID = "HomeSearchView"
    private let HKRecommendCityID = "RecommendCityView"
    private let HKStoryID = "StoryView"
    private let HeaderViewID = "HomeHeaderReusableView"
    
    lazy var Tilte: UILabel = {
       let label = UILabel()
        label.text = "发现"
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)
        //label.backgroundColor = .red
        return label
    }()
    
    lazy var location: UILabel = {
       let label = UILabel()
        label.text = "定位中.."
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        //label.backgroundColor = .red
        return label
    }()
    
    lazy var weather: UILabel = {
       let label = UILabel()
        label.text = "获取天气中.."
        label.textColor = UIColor.init(r: 56, g: 56, b: 56)
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        //label.backgroundColor = .red
        return label
    }()
    
    lazy var locationIcon:UIImageView = {
       let vi = UIImageView()
        vi.image = UIImage(named: "home_detail_location")
        //vi.backgroundColor = .cyan
        return vi
    }()
    
    lazy var weatherIcon:UIImageView = {
       let vi = UIImageView()
        vi.image = UIImage(named: "")
      //  vi.backgroundColor = .cyan
        return vi
    }()
    /// 右边功能按钮
    lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
       // button.frame = CGRect(x:10, y:100, width:40, height: 40)
        //button.addTarget(self, action: #selector(tip), for: UIControl.Event.touchUpInside)
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
            return collection
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(){
        
    }
    
    func configUI(){
        self.backgroundColor = backColor
        addSubview(Tilte)
        addSubview(rightBarButton)
        addSubview(collectionView)
        addSubview(locationIcon)
        addSubview(location)
        addSubview(weather)
        addSubview(weatherIcon)
        
        Tilte.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(55)
        }
        rightBarButton.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(Tilte.snp.centerY)
        }
        
        locationIcon.snp.makeConstraints { (make) in
            make.width.equalTo(13)
            make.height.equalTo(20)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(Tilte.snp.bottom).offset(10)
        }
        location.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.left.equalTo(locationIcon.snp.right).offset(8)
            make.centerY.equalTo(locationIcon.snp.centerY)
        }
        weatherIcon.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(location.snp.right).offset(20)
            make.centerY.equalTo(locationIcon.snp.centerY)
        }
        weather.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.left.equalTo(weatherIcon.snp.right).offset(5)
            make.centerY.equalTo(locationIcon.snp.centerY)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(340)
        }
    }

}
// MARK - 数据源

extension HKHomeHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HKRecommendCityID, for: indexPath) as! RecommendCityView
            cell.datas = self.cityData
            cell.delegate = self
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

extension HKHomeHeaderView:  UICollectionViewDelegate {
    
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
            delegate?.searchClicks()
        }else {
           
        }
    }
}
// MARK -  点击代理事件

extension HKHomeHeaderView: CityDelegate {
    func cityClick(with data: String) {
        delegate?.cityClicks(with: data)
//        let vc = SearchContentViewController(word: data)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
