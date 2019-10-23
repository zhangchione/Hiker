//
//  AlbumShowViewController+Config.swift
//  VCFactory
//
//  Created by nine on 2018/9/26.
//

import Foundation
import Photos
import CollectionKit

extension AlbumShowViewController {
    func configGesture() {
        panGR.addTarget(self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
    }

    func setTitle(with asset: PHAsset) {
        guard let createDate = asset.creationDate else { return }
        let yearMat = DateFormatter()
        yearMat.dateFormat = "YYYY"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "YYYY年MM月dd日"
        let mouthFormatter = DateFormatter()
        mouthFormatter.dateFormat = "MM月dd日"

        updateDelectButton(DataSingle.shared.delectPhots.value.count)

        titleLabel.text = "\(currentPage+1)/\(photos.count)"
        if yearMat.string(from: createDate) == yearMat.string(from: Date()) {
            timeLabel.text = mouthFormatter.string(from: createDate)
            timeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(65)
            }
        } else {
            timeLabel.text = yearFormatter.string(from: createDate)
            timeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(120)
            }
        }
    }

    func updateTitleDot(isLocal: Bool) {
        localStatuDot.tintColor = isLocal ? UIColor(rgb: 0x2ADAD5) : UIColor(rgb: 0xCCD3D3)
    }
    func updateTitleDot(isDelect: Bool) {
        if isDelect {
            localStatuDot.tintColor = UIColor.red
        }
    }

    func configClassifyCollectionView() {
        //        var datas = DataSingle.shared.myAlbums.map { $0.key }.filter { AlbumHelper.isAppAlbum($0) }
        //        var dataSource = ArrayDataSource(data: DataSingle.shared.myAlbums.map { $0.key }.filter { AlbumHelper.isAppAlbum($0) })
        let viewSource = ClosureViewSource(viewUpdater: { (view: AlbumShowBottomCell, category: String, _: Int) in
            if self.currentSelectedCategorys.contains(category) {
                view.backgroundColor = UIColor(rgb: 0x2ADAD5)
            } else {
                view.backgroundColor = UIColor(rgb: 0xCCD3D3)
            }
            self.load(photos: DataSingle.shared.myAlbums[category]?.photos, in: view)
            view.label.text = "\(I18n.localizedString(category))"
        })
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            return CGSize(width: 99.fit, height: 99.fit)
        }
        let provider = BasicProvider<String, AlbumShowBottomCell>(
            dataSource: bottomDataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.tapHandler = { context in
            let photo = self.photos[self.currentPage]
            AlbumHelper.createAndSave(context.data, with: [photo.asset], callBack: { (isSucess) in
                DispatchQueue.main.async {
                    if isSucess {
                        let feedback = UIImpactFeedbackGenerator()
                        feedback.prepare()
                        feedback.impactOccurred()
                        self.jump(to: self.currentPage+1)
                    } else {
                        NoticeHelper.showError(I18n.localizedString("album_save_fali"))
                    }
                }
            })
        }
        let inset = UIEdgeInsets(top: 11.fit, left: 11.fit, bottom: 11.fit, right: 0)
        provider.layout = RowLayout(spacing: 11, justifyContent: .start).inset(by: inset)
        provider.animator = ScaleAnimator()
        bottomCollectionView.provider = ComposedProvider(layout: RowLayout(), sections: [provider, addPhotoProvide()])
    }
    private func addPhotoProvide() -> BasicProvider<String, AddAlbumShowCell> {
        let dataSource = ArrayDataSource(data: [""])
        let viewSource = ClosureViewSource(viewUpdater: { (_: AddAlbumShowCell, _: String, _: Int) in
            //            view.configUI()
        })
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            return CGSize(width: 99.fit, height: 99.fit)
        }
        let provider = BasicProvider<String, AddAlbumShowCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.tapHandler = {  _ in
            let creationAction = UIAlertAction(title: I18n.localizedString("new_album"), style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
                let showNewAlert = AlbumHelper.showNewLocalAlert { [weak self] nameStr in
                    DispatchQueue.main.async {
                        NoticeHelper.shake(style: .light)
                        if let str = nameStr {
                            self?.bottomDataSource.data.append(str)
                            NoticeHelper.showSuccess(I18n.localizedString("new_success"))
                        } else {
                            NoticeHelper.showError(I18n.localizedString("new_failure"))
                        }
                    }
                }
                self?.present(showNewAlert, animated: true)
            })
            let addLocalAlert = AlbumHelper.showAddLocalAlert(actions: [creationAction]) { [weak self] str in
                NoticeHelper.shake(style: .light)
                self?.bottomDataSource.data.append(str)
            }
            self.present(addLocalAlert, animated: true, completion: nil)
        }
        let inset = UIEdgeInsets(top: 11.fit, left: 11.fit, bottom: 11.fit, right: 0)
        provider.layout = RowLayout(spacing: 11, justifyContent: .start).inset(by: inset)
        return provider
    }
}

extension AlbumShowViewController {
    func load(photos: [Photo]?, in cell: AlbumShowBottomCell) {
        guard let photos = photos else { return }
        var index = 0
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        if photos.count > index {
            manager.requestImage(for: photos[index].asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFill, options: option) { (thumbnailImage, _) in
                cell.imageView.image = thumbnailImage
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
