//
//  TKPhotoBaseViewController.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import Hero
import Photos

import AssetsLibrary
import SwifterSwift
import DifferenceKit
import RxSwift
import RxCocoa
import SwiftMessages
import LYEmptyView
extension Date: Differentiable {}

typealias PhotoData = ArraySection<Date, Photo>

class TKPhotoBaseViewController: SubClassBaseViewController {
    let manager = PHImageManager.default()
    var categoryFormatter = "YYYYMM"
    var photos: [Photo]?
    var categoryPhotos = [PhotoData]()
    var categoryPImages = [[UIImage]]()
    // MARK: Config CollectionView
    var columns: CGFloat = 3
    var edge: CGFloat = 20
    var spacing: CGFloat = 4
    var semaphore =  DispatchSemaphore(value: 1)
    let reloadQueue = DispatchQueue(label: "zc.cc.photoBaseReload", attributes: .concurrent)
    var currentShowVC: AlbumShowViewController?
    lazy var selectedBanner: PhotoBottonBanner = {
        let actions = PhotoBottonBannerActions(deleteCallBack: {
            NoticeHelper.showNotice("", "loading...", theme: .success, layout: .statusLine, duration: .forever)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(Array(self.selectedsSet).map {$0.asset} as NSFastEnumeration)
            }) { (isSuccess, _) in
                DispatchQueue.main.async {
                    if isSuccess {
                        if self.photos != nil {
                            self.photos = self.photos!.filter { !self.selectedsSet.contains($0)}
                            self.disableSelected()
                            self.reloadData()
                        }
                    }
                    SwiftMessages.hideAll()
                    NoticeHelper.showSuccess("")
                }
            }
        }, shareCallBack: {}, addCallBack: {
            let v = PhotoAddPickerViewController() { cv in
                AlbumHelper.saveAsset(cv, with: Array(self.selectedsSet).map {$0.asset}, callBack: { isSucess in
                    if isSucess {
                        DispatchQueue.main.async {
                            NoticeHelper.showSuccess("")
                            self.disableSelected()
                        }
                    } else {
                        NoticeHelper.showError("")
                    }
                })

            }
            v.view.backgroundColor = .white
        })
        let v = PhotoBottonBanner(actions: actions)
        //v.frame = CGRect(x: 0, y: view.frame.height-(54+UIScreen().safeAreaInsets.bottom), width: view.frame.width, height: 54+UIScreen().safeAreaInsets.bottom)
        return v
    }()
    lazy var cellSize: CGSize = CGSize(width: (UIScreen.main.bounds.width - edge*2 - spacing*(columns-1))/columns,
                                       height: (UIScreen.main.bounds.width - edge*2 - spacing*(columns-1))/columns)
    lazy var headerCellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - edge*2,
                                             height: 50)
    var firstCellHeroId: String?
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        return layout
    }()
    lazy var option: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        return option
    }()
    lazy var collectionView: SwipeSelectingCollectionView = {
        let cv = SwipeSelectingCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.swipteDelegate = self
        cv.showsHorizontalScrollIndicator = false
        if TKPhotoBaseViewController.isRightPhoto() {
            cv.ly_emptyView = LYEmptyView.empty(withImageStr: "notice_loading", titleStr: "image_loading", detailStr: "please_wait")
        } else {
            cv.ly_emptyView = LYEmptyView.empty(withImageStr: "notice_loading", titleStr: "no_albums_permission", detailStr: "go_to_setting")
        }
        return cv
    }()
    var disposeBag = DisposeBag()
    
    var selectedsSet = Set<Photo>() {
        didSet {
            title = "\(selectedsSet.count)"
        }
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override  func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.register(PhotoCell1.self, forCellWithReuseIdentifier: "item")
        collectionView.register(PhotoHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerReusableView")
        configUI()
        configNav()
        configSource()
    }
    // MARK: Config
    func configSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
        DataSingle.shared.delectPhots.asObservable().distinctUntilChanged { $0.count == $1.count}.subscribe({[weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }

    override func configNav() { super.configNav() }

    func configUI() {
        view.addSubview(collectionView)
        navigationItem.leftItemsSupplementBackButton = true
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

    static func isRightPhoto() -> Bool {
        let authStatus = ALAssetsLibrary.authorizationStatus()
        return authStatus != .restricted && authStatus != .denied
    }

    func upCategoryPhotos(finish: (_ categoryPhotos: [PhotoData]) -> Void) {
        guard let photos = photos?.filter({ !(DataSingle.shared.delectPhots.value.contains($0)||DataSingle.shared.hadDelectPhotos.contains($0)) }), categoryPhotos.count != photos.count else { return }
        finish(sortPhoto(photos))
    }

    func showVC(_ asset: PHAsset, with image: UIImage) {
        guard let index = self.photos?.firstIndex(where: { (p) -> Bool in
            return p.asset.localIdentifier == asset.localIdentifier
        }), let photos = self.photos else { return }
        currentShowVC = AlbumShowViewController(to: index, with: photos)
        //        currentShowVC?.view.hero.modifiers = [.duration(0.1)]
        //        currentShowVC?.delegate = self
        //self.present(currentShowVC!, animated: true, completion: nil)
    }

    
    func changeNav(with isOpenChoice: Bool) {
        if isOpenChoice {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(disableSelected))
            navigationItem.rightBarButtonItem?.tintColor = Color(hexString: "#2ADAD5")
            //view.addSubview(selectedBanner)
        } else {
            selectedBanner.removeFromSuperview()
            title = ""
            navigationItem.rightBarButtonItem = nil
            configNav()
        }
    }
    
}

// MARK: - CollectionViewDelegate
extension TKPhotoBaseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 如果是正在选择，则不响应点击事件
               if let cv = collectionView as? SwipeSelectingCollectionView, cv.isOpenChoice {
                   selectedsSet.insert(categoryPhotos[indexPath.section].elements[indexPath.item])
                   return
               }
               let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
               option.resizeMode = .exact
               option.isSynchronous = true
               manager.requestImage(for: categoryPhotos[indexPath.section].elements[indexPath.item].asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: option) { (thumbnailImage, _) in
                   if let image = thumbnailImage {
                      
                    
                    self.showVC(self.categoryPhotos[indexPath.section].elements[indexPath.item].asset, with: image)
                   } else {
                       self.manager.requestImage(for: self.categoryPhotos[indexPath.section].elements[indexPath.item].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFit, options: option) { (thumbnailImage, _) in
                           if let image = thumbnailImage { self.showVC(self.categoryPhotos[indexPath.section].elements[indexPath.item].asset, with: image) }
                       }
                   }
               }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cv = collectionView as? SwipeSelectingCollectionView, !cv.isOpenChoice { return }
        selectedsSet.remove(categoryPhotos[indexPath.section].elements[indexPath.item])
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension TKPhotoBaseViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return headerCellSize
    }
}
// MARK: - CollectionViewDataSource
extension TKPhotoBaseViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categoryPhotos.count > 0 { collectionView.ly_hideEmpty() }
        return categoryPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPhotos[section].elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? PhotoCell1)!
        imageCell.delegate = self
        manager.requestImage(for: categoryPhotos[indexPath.section].elements[indexPath.item].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFit, options: option) { (thumbnailImage, _) in
            if let image = thumbnailImage {
                imageCell.imageView.image = image
            }
        }
        imageCell.imageView.hero.id = "albumCellImage_\(categoryPhotos[indexPath.section].elements[indexPath.item].asset.localIdentifier)"
        return imageCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerIdentifie = "headerReusableView"
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifie, for: indexPath) as? PhotoHeaderReusableView else {
            return UICollectionReusableView()
        }
        let photo = categoryPhotos[indexPath.section].elements[indexPath.item]

        let yearMat = DateFormatter()
        yearMat.dateFormat = "YYYY"
        let mouthFormatter = DateFormatter()
        mouthFormatter.dateFormat = "MM.dd"

        headerView.dateLabel.text = mouthFormatter.string(from: photo.createTime ?? Date())
        headerView.yearLabel.text = yearMat.string(from: photo.createTime ?? Date())

        return headerView
    }

}
// tool
extension TKPhotoBaseViewController {
    func reloadData(animated: Bool = true) {
        reloadQueue.async {
            self.upCategoryPhotos(finish: { (categoryPhotos) in
                DispatchQueue.main.sync {
                    if animated {
                        let changeset = StagedChangeset(source: self.categoryPhotos, target: categoryPhotos)
                        self.collectionView.reload(using: changeset) { data in
                            self.categoryPhotos = data
                        }
                    } else {
                        self.categoryPhotos = categoryPhotos
                    }
                }
            })
        }
    }

    func sortPhoto(_ photos: [Photo]) -> [PhotoData] {
        var current = 0
        var res = [PhotoData]()
        var tempDic = [String: [Photo]]()
        for p in photos {
            current += 1
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            let category = dateformatter.string(from: p.createTime ?? Date())

            if tempDic[category] == nil { tempDic[category] = [Photo]() }
            tempDic[category]?.append(p)
        }

        if current == photos.count {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            let currentDate = dateformatter.string(from: Date())
            // 日期排序
            let sort = tempDic.sorted { (a, b) -> Bool in
                guard Int(a.key)! <= Int(currentDate)! else { return false }
                return Int(a.key)! > Int(b.key)!
            }
            //            res = sort.map { $0.value }
            // 时间排序
            sort.enumerated().forEach { (i, value) in
                var photos = value.value
                dateformatter.dateFormat = "yyyyMMddHHmmss"
                photos = photos.sorted(by: { (a, b) -> Bool in
                    guard let aTime = a.createTime, let bTime = b.createTime else { return false }
                    return Double(dateformatter.string(from: aTime))! > Double(dateformatter.string(from: bTime))!
                })
                guard let date = photos.first?.createTime else { return }
                res.insert(PhotoData.init(model: date, elements: value.value), at: i)
            }
        }
        return res
    }

    @objc func disableSelected() {
        selectedsSet.removeAll()
        collectionView.deSelectAll()
        collectionView.isOpenChoice = false
    }
}

extension TKPhotoBaseViewController: PhotoCell1Delegate {
    func canSelected() -> Bool {
        return collectionView.isOpenChoice
    }
}
/// 滑动CV代理
extension TKPhotoBaseViewController: SwipeSelectingDelegate {
    func selecteStatusChange(_ collectionView: SwipeSelectingCollectionView, with isOpenChoice: Bool) {
        changeNav(with: isOpenChoice)
    }
}
