//
//  TracksViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/22.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import Photos

class TracksViewController:  SubClassBaseViewController, DataToEasyDelegate {
    lazy var tipLabel = UILabel()
    
    var finishLoad = false
    var isReloading =  false
    
        func recognize(current: Int, max: Int) {
                DispatchQueue.main.async {
                           self.tipLabel.text = "第一次配图需要给系统照片分类，正在分类图片\(current)/\(max)，分类期间如遇到数字卡死，请重启App再次进入分类"

            }
            let isNumberOK = current%100 == 0 || (current==1) || (current%20==0&&current<100)
            guard (isNumberOK && isReloading == false) || max <= current else { return }
            if max == 0 { self.finishLoad = true }
            DispatchQueue.main.async {
                self.isReloading = true
                if Double(current)/Double(max) >= 0.99 {
//                    self.tipLabel.snp.updateConstraints({ (make) in
//                        make.height.equalTo(0)
//                    })
                    self.tipLabel.isHidden = true

                }
                self.configData()
            }
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1) {
                self.isReloading = false
            }
    }
    var albums = [Album]()
    var data = [1,2,3,4]
    var photoDataManager: PhotoDataManager
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = backColor
        
        // 注册头部视图
        collection.register(TrackHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackHeaderReusableView")
        
        collection.register(TrackCell.self, forCellWithReuseIdentifier: "TrackCell")
//        collection.register(RecommendCityView.self, forCellWithReuseIdentifier: HKRecommendCityID)
//        collection.register(StoryView.self, forCellWithReuseIdentifier: HKStoryID)
        collection.showsHorizontalScrollIndicator  = false
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()
    
        init(_ photoDataManager: PhotoDataManager) {
        self.photoDataManager = photoDataManager
        super.init(nibName: nil, bundle: nil)
        self.photoDataManager.dataToEasyDelegate = self
        }
    
        
        required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configNav()
        configData()
    }
    override func configNav(){
        self.navigation.item.title =  "足迹"
       self.navigation.bar.backgroundColor = backColor
    }
    func configData(){
        albums = DataSingle.shared.locationAlbums.map { $0.value }
        print(albums)
        self.collectionView.reloadData()
    }
    
    func configUI(){
        view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view)
            make.width.equalTo(TKWidth)
            make.height.equalTo(TKHeight)
        }
        view.backgroundColor = backColor
        view.addSubview(tipLabel)
        tipLabel.numberOfLines = 0
        tipLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-10)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
        }
    }
}

extension TracksViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let identifier = "story\(indexPath.section)\(indexPath.row)"
            self.collectionView.register(TrackCell.self, forCellWithReuseIdentifier: identifier)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TrackCell
            //cell.backgroundColor = .red
    
            config(cell, with: albums[indexPath.row])
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
            return 10

    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: TKWidth, height: 180)
    }
    
    // 头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackHeaderReusableView", for: indexPath) as? TrackHeaderReusableView else {
            return UICollectionReusableView()
        }
        headerView.titleLabel.text = ""
        headerView.titleLabel.textColor = UIColor.init(r: 146, g: 146, b: 146)
        headerView.titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: 414, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//           let model = data[indexPath.row]
//            let vc = StoryViewController(model: model)
//            self.navigationController?.pushViewController(vc, animated: true)
        let vc = CustomPhotoViewController(album: albums[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TracksViewController {
    func config(_ cell: TrackCell, with album: Album) {
        let key = album.key
        let photos = album.photos
        _ = 0
        cell.titleLabel.text = "#" + album.name + "#"
        
        load(photos: photos, in: cell)
    }
    func load(photos: [Photo], in cell: TrackCell) {
        var index = 0
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        if photos.count > index {
            manager.requestImage(for: photos[index].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill, options: option) { (thumbnailImage, _) in
                cell.imageView1.image = thumbnailImage
            }
        }
        if photos.count > index+1 {
            index += 1
            manager.requestImage(for: photos[index].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill, options: option) { (thumbnailImage, _) in
                cell.imageView2.image = thumbnailImage
            }
        } else {
            cell.imageView2.image = nil
        }
        if photos.count > index+1 {
            index += 1
            manager.requestImage(for: photos[index].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill, options: option) { (thumbnailImage, _) in
                cell.imageView3.image = thumbnailImage
            }
        } else {
            cell.imageView3.image = nil
        }
    }
}
