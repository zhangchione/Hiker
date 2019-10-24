//
//  CustomPhotoViewController.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import Photos
import SwiftMessages
import SwifterSwift
import LYEmptyView

class CustomPhotoViewController: TKPhotoBaseViewController {
    
//    ///资源管理
//    let rescouceManager = RescouceManager.share
//    ///配置管理
//    let rescoucceConfiguration = RescouceConfiguration.share
    
    let bannerView: PhotoBannerView
    let photoBannerViewModel: PhotoBannerViewModel
    let bannerHeight: CGFloat = 86+44+UIScreen().titleY
    var isLoadedFinish = false
    var isShowNav = false {
        willSet {
            guard newValue != isShowNav, isLoadedFinish else { return }
            navigationController?.navigationBar.isHidden = !newValue
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(album: Album, firstId: String? = nil) {
        photoBannerViewModel = PhotoBannerViewModel(with: album)
        bannerView = PhotoBannerView(with: photoBannerViewModel)
        super.init()
        self.photos = album.photos
        photoBannerViewModel.saveCallBack = { [weak self] in
            self?.createCurrentAlbum()
        }
        photoBannerViewModel.delectCallBack = { [weak self] in
            self?.deleteCurrentAlbum()
        }
        photoBannerViewModel.backCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        photoBannerViewModel.removeCallBack = { [weak self] in
            self?.removeAlbums()
        }
        bannerView.saveButton.addTarget(self, action: #selector(AR), for: .touchUpInside)
        
        bannerView.viewModel = photoBannerViewModel
        bannerView.backgroundImageView.image = UIImage(named: "zhuzhou")
        if TKPhotoBaseViewController.isRightPhoto() {
            collectionView.ly_emptyView = LYEmptyView.empty(withImageStr: "notice_loading", titleStr: "没有照片", detailStr: "请添加一张")
        }
        setupBanner()
    }

    @objc func AR(){
        print("进入AR展示")
//                guard let photos = self.photos else { return }
//        var albumVC: TKARViewController!
//        let storB = UIStoryboard.init(name: "ARPanorama", bundle: nil)
//        albumVC = storB.instantiateViewController(withIdentifier: "TKARViewController") as? TKARViewController
//        DispatchQueue.global(qos: .userInteractive).sync {
//            let manager = RescouceManager.share
//            let imageManager = PHImageManager.default()
//            let option = PHImageRequestOptions()
//            option.isSynchronous = true
//
//            if manager.horizontalImages.count > 0 {
//                for image in manager.horizontalImages {
//                    manager.deleteHorizontalImage(image: image)
//                }
//            }
//            if manager.verticalImages.count > 0 {
//                for image in manager.verticalImages {
//                    manager.deleteVerticalImage(image: image)
//                }
//            }
//
//            for _ in 0...10 {
//                imageManager.requestImage(for: photos[Int(arc4random_uniform(UInt32(photos.count)))].asset,
//                                          targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill,
//                                          options: option) {(thumbnailImage, _) in
//                                            manager.addHorizontalImage(image: thumbnailImage ?? UIImage())
//                }
//            }
//            for _ in 0...10 {
//                imageManager.requestImage(for: photos[Int(arc4random_uniform(UInt32(photos.count)))].asset,
//                                          targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill,
//                                          options: option) {(thumbnailImage, _) in
//                                            manager.addVerticalImage(image: thumbnailImage ?? UIImage())
//                }
//            }
//
//
//
//
//         manager.text = "欢迎来到“行迹”AR相册体验馆~"
//         manager.textColor = "textColor_7"
//        }
//
//        DispatchQueue.global(qos: .background).async {
//            var path=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            path+="/RescouceManager"
//            NSKeyedArchiver.archiveRootObject(self.rescouceManager, toFile: path)
//            var cPath=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            cPath+="/RescouceConfiguration"
//            print("路径："+cPath)
//            NSKeyedArchiver.archiveRootObject(self.rescoucceConfiguration, toFile: cPath)
//        }
//        albumVC.hero.isEnabled = true
//        albumVC.view.hero.modifiers = [.fade, .scale(0.1)]
//        albumVC.navigationItem.title = " "
//        navigationController?.pushViewController(albumVC, animated: true)
    }
    @objc func createCurrentAlbum() {
        self.create(photos: self.photoBannerViewModel.album.photos, name: self.photoBannerViewModel.album.name)
    }

    @objc func deleteCurrentAlbum() {
        guard let albumAsset = self.photoBannerViewModel.assetAlbum() else { return }
        self.delect(album: albumAsset, name: self.photoBannerViewModel.album.name)
    }
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNav()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
    }
    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "home_icon_backwhite"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.isLoadedFinish = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

    func updateNavRightButton() {
        if photoBannerViewModel.album.type == .custom {
            if photoBannerViewModel.saved {
                navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(image: UIImage(named: "album_delete_black")?.original, style: UIBarButtonItem.Style.plain, target: self, action: #selector(removeAlbums)),
                    UIBarButtonItem(image: UIImage(named: "albums_saved_black")?.original, style: UIBarButtonItem.Style.plain, target: self, action: #selector(deleteCurrentAlbum))
                ]
            } else {
                navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(image: UIImage(named: "album_delete_black")?.original, style: UIBarButtonItem.Style.plain, target: self, action: #selector(removeAlbums)),
                    UIBarButtonItem(image: UIImage(named: "albums_save_black")?.original, style: UIBarButtonItem.Style.plain, target: self, action: #selector(createCurrentAlbum))
                ]
            }
        } else {
            if photoBannerViewModel.saved {
                navigationItem.rightBarButtonItem=UIBarButtonItem(image: UIImage(named: "albums_saved_black")?.original, style: UIBarButtonItem.Style.plain, target: self, action: #selector(deleteCurrentAlbum))
            } else {
                navigationItem.rightBarButtonItem=UIBarButtonItem(image: UIImage(named: "ar_black")?.original, style: UIBarButtonItem.Style.plain, target: self, action: #selector(AR))
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(back))
                
            }
        }
    }
//    @objc func back() {
//        self.navigationController?.popViewController(animated: true)
//    }
    private func setupBanner() {
        // 86为ui高度，44为标题栏高度
        collectionView.contentInset =
            UIEdgeInsets(top: bannerHeight, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(bannerView)
        guard self.bannerView.viewModel.album.photos.count > 0 else { return }
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.resizeMode = .exact
        option.isSynchronous = true
        self.manager.requestImage(for: self.bannerView.viewModel.album.photos[0].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFit, options: option) { (thumbnailImage, _) in
            if let image = thumbnailImage {
                let viewModel = self.bannerView.viewModel
                viewModel.image = image
                self.bannerView.viewModel = viewModel
            }
        }

    }

    override func configNav() {
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        navigationController?.navigationBar.prefersLargeTitles = true
        let cityName =  photoBannerViewModel.album.name
        let citeKey = cityName.substring(to: 2) + "之回忆"
        title = citeKey
        updateNavRightButton()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = bannerHeight + scrollView.contentOffset.y
        if offset < 0 {
            bannerView.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: UIScreen.main.bounds.width, height: abs(scrollView.contentOffset.y))
        } else {
            bannerView.frame = CGRect(x: 0, y: -bannerHeight, width: UIScreen.main.bounds.width, height: bannerHeight)
        }
        if offset > 88 {
            isShowNav = true
        } else {
            isShowNav = false
        }
    }
    /// 改变标题栏样式
    override func changeNav(with isOpenChoice: Bool) {
        if isOpenChoice {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(disableSelected))
            navigationItem.rightBarButtonItem?.tintColor = Color(hexString: "#2ADAD5")
            //view.addSubview(selectedBanner)
        } else {
            navigationController?.navigationBar.isHidden = (bannerHeight + collectionView.contentOffset.y < 88)
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            selectedBanner.removeFromSuperview()
            title = ""
            navigationItem.rightBarButtonItem = nil
            configNav()
        }
    }
}

extension CustomPhotoViewController {
    @objc private func removeAlbums() {
        let alertController = UIAlertController(title: "delete_custom_album", message: self.photoBannerViewModel.saved ? "delete_custom_album_notice" : "delete_custom_album_notice_nosaved", preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController()
//            DataSingle.shared.deleteCustomAlbum(with: [self.photoBannerViewModel.album.name])
            NoticeHelper.showSuccess("album_delete_sucess")
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    func delect(album: PHAssetCollection, name: String) {
        let alertController = UIAlertController(title: "delect_album", message: "need_keep_system_albu", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        let keepAction = UIAlertAction(title: "keep", style: UIAlertAction.Style.default, handler: { _ in
            AlbumHelper.delectLocalAlbum(with: [name])
            NoticeHelper.shake(style: .medium)
            NoticeHelper.showSuccess(name + "album_delete_sucess")
            DispatchQueue.main.async {
                self.bannerView.updateUI()
                self.updateNavRightButton()
            }
        })
        let delectAction = UIAlertAction(title: "dontkeep", style: UIAlertAction.Style.destructive, handler: { _ in
            AlbumHelper.delete(asset: album, callBack: { (success) in
                guard success else { return }
                AlbumHelper.delectLocalAlbum(with: [name])
                NoticeHelper.shake(style: .medium)
                NoticeHelper.showSuccess(name + "album_delete_sucess")
                DispatchQueue.main.async {
                    self.bannerView.updateUI()
                    self.updateNavRightButton()
                }
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(keepAction)
        alertController.addAction(delectAction)
        self.present(alertController, animated: true, completion: nil)
    }

    private func create(photos: [Photo], name: String) {
        NoticeHelper.shake(style: .medium)
        NoticeHelper.showNotice("saving", theme: .success, duration: .forever)
        AlbumHelper.createAndSave(name, with: photos.map { $0.asset }, callBack: { (success) in
            SwiftMessages.hideAll()
            if success {
                DispatchQueue.main.async {
                    self.bannerView.updateUI()
                    self.updateNavRightButton()
                }
                AlbumHelper.insertLocalAlbum(with: name)
            } else {
                NoticeHelper.showError("album_save_fali")
            }
        })
    }
}
