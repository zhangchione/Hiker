//
//  RecommendCityView.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

// 图片按钮点击代理方法
protocol CityDelegate:NSObjectProtocol {
    func cityClick(with data:String)
}

class RecommendCityView: UICollectionViewCell {
    
    weak var delegate: CityDelegate?
    
    public var datas = [City]()
    
    private let CityCellID = "CityView"
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 140, height:200)
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backColor
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(CityView.self, forCellWithReuseIdentifier: CityCellID)
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    func setUpUI(){
        self.backgroundColor = backColor
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in

            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(AdaptW(394))
            make.height.equalTo(200)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension RecommendCityView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCellID, for: indexPath) as! CityView
    
        let data = datas[indexPath.row]
        
        cell.imageView.image = UIImage(named: data.img! )
        cell.titleLabel.text = data.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        delegate?.cityClick(with: data.title!)
    }
    

}
