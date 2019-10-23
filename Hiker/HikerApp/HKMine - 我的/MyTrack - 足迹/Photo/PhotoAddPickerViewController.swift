//
//  PhotoAddPickerViewController.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import Photos
import CollectionKit
import SwifterSwift
class PhotoAddPickerViewController: BottomPopupViewController {
    typealias PhotoAddPickerCallBack = (PHAssetCollection) -> Void
    let callBack: PhotoAddPickerCallBack
    /// 顶部文案
    var label: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var pickerCollectionView: CollectionView = {
        let cv = CollectionView()
        return cv
    }()
    init(callBack: @escaping PhotoAddPickerCallBack) {
        self.callBack = callBack
        super.init(nibName: nil, bundle: nil)
        configUI()
        setupCollectionView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {
        view.addSubview(label)
        view.addSubview(pickerCollectionView)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(22)
            make.height.equalTo(25)
            make.width.equalTo(80)
        }
        pickerCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.width.equalTo(370)
            make.top.equalToSuperview().inset(77)
            make.bottom.equalToSuperview()
        }
    }

    func setupCollectionView() {
        let myAlbums = DataSingle.shared.myAlbums.map { $0.value }
        let dataSource = ArrayDataSource(data: myAlbums)
        let viewSource = ClosureViewSource(viewUpdater: { (view: PhotoAddPickerCell, album: Album, _: Int) in
            view.updateUI(with: album)
        })
        let sizeSource = { (index: Int, data: Album, collectionSize: CGSize) -> CGSize in
            return CGSize(width: 370.fit, height: 67)
        }
        let provider = BasicProvider<Album, PhotoAddPickerCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.tapHandler = {  context in
            guard let asset = AlbumHelper.findAlbum(with: context.data.name) else { return }
            AlbumHelper.insertLocalAlbum(with: context.data.name)
            self.callBack(asset)
            self.dismiss(animated: true, completion: nil)
        }
        let inset = UIEdgeInsets(top: 0, left: 22.fit, bottom: 0, right: 22.fit)
        provider.layout = FlowLayout(spacing: 11, justifyContent: .start).inset(by: inset)
        pickerCollectionView.backgroundColor = .white
        pickerCollectionView.provider = provider
    }

    override func getPopupHeight() -> CGFloat {
        return CGFloat(590+UIScreen().safeAreaInsets.bottom)
    }

    override func getPopupTopCornerRadius() -> CGFloat {
        return CGFloat(10)
    }

    override func getPopupPresentDuration() -> Double {
        return 0.25
    }

    override func getPopupDismissDuration() -> Double {
        return 0.25
    }

    override func shouldPopupDismissInteractivelty() -> Bool {
        return true
    }
}
