//
//  AlbumHelper.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import Photos
import UIKit

// Tool
class AlbumHelper {
    
    static func fetchNumberOfPhotos(from begin: Date, to end: Date, completion: @escaping (_ photos: [Photo]) -> Void) {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@ AND mediaType == %i", end as NSDate, begin as NSDate, PHAssetMediaType.image.rawValue)

        options.predicate = predicate
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        options.includeHiddenAssets = true
        options.includeAllBurstAssets = true
        options.includeAssetSourceTypes = [.typeUserLibrary]

        var photos: [Photo] = []
        let fetchRequest = PHAsset.fetchAssets(with: options)
        PHPhotoLibrary.shared().performChanges({
            fetchRequest.enumerateObjects({ (asset, _, _) in
                photos.append(Photo(asset))
            })
        }) { (_, _) in
            completion(photos)
        }
    }

    static func create(asset name: String, callBack: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }) { (isSuccess, _) in
            callBack(isSuccess)
        }
    }

    static func delete(asset assetAlbum: PHAssetCollection, callBack: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.deleteAssetCollections([assetAlbum] as NSFastEnumeration)
        }) { (isSuccess, _) in
            callBack(isSuccess)
        }
    }

    static func findAlbum(with albumName: String) -> PHAssetCollection? {
        var assetCollection: PHAssetCollection?
        let list = PHAssetCollection
            .fetchAssetCollections(with: .album, subtype: .any, options: nil)
        list.enumerateObjects({ (album, _, stop) in
            if albumName == album.localizedTitle {
                assetCollection = album
                stop.initialize(to: true)
            }
        })
        return assetCollection
    }

    static func saveAsset(_ assetAlbum: PHAssetCollection, with assets: [PHAsset], callBack: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            //            let collection = PHAssetCollection.init
            let albumChangeRequset = PHAssetCollectionChangeRequest(for: assetAlbum)
            albumChangeRequset?.addAssets(assets as NSFastEnumeration)
        }, completionHandler: { (isSucess, _) in
            callBack(isSucess)
        })
    }

    static func createAndSave(_ albumName: String, with assets: [PHAsset], callBack: ((Bool) -> Void)?) {
        // 查找是否有改相册，没有的话创建
        guard let assetAlbum = AlbumHelper.findAlbum(with: albumName) else {
            AlbumHelper.create(asset: albumName) { isSuccess in
                if isSuccess {
                    AlbumHelper.createAndSave(albumName, with: assets, callBack: callBack)
                } else {
                    callBack?(false)
                }
            }
            return
        }
        AlbumHelper.saveAsset(assetAlbum, with: assets) { isSuccess in
            if isSuccess {
                callBack?(true)
            } else {
                callBack?(false)
            }
        }
    }

    static func isAppAlbum(_ key: String) -> Bool {
        let localAlbum = DataBase.shared.querylocalAlbumName()
        return localAlbum.contains(key)
    }
    //    添加本地相册
    static func showAddLocalAlert(actions: [UIAlertAction] = [], callBack: ((String) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: "add_album", message: "chose_you_want_add_album", preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let myAlbums = DataSingle.shared.myAlbums.filter { !AlbumHelper.isAppAlbum($0.key) }
        for album in myAlbums {
            alertController.addAction(UIAlertAction(title: "\(album.key)(\(album.value.photos.count))", style: UIAlertAction.Style.default, handler: { _ in
                AlbumHelper.insertLocalAlbum(with: album.key)
                callBack?(album.key)
            }))
        }
        return alertController
    }
    static func addAllLocalAlbumAlert(callBack: (() -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: "导入所有本地相册", message: "导入后的相册会被App视为已整理，该操作不会对系统相册有任何影响", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        // 保留系统本地，只删除app
        let keepAction = UIAlertAction(title: "导入", style: UIAlertAction.Style.default, handler: { _ in
            let albums = DataSingle.shared.myAlbums.filter { !AlbumHelper.isAppAlbum($0.key) }
            for album in albums {
                AlbumHelper.insertLocalAlbum(with: album.key)
                callBack?()
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(keepAction)
        return alertController
    }
    //    新建相册
    static func showNewLocalAlert(callBack: ((String?) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: "输入你要新建的相册名", message: "新建一个系统本地相册", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: {
            (textfield: UITextField) -> Void in
            textfield.placeholder = "相册名"
        })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) {
            (_) -> Void in
        })
        alertController.addAction(UIAlertAction(title: "新建", style: UIAlertAction.Style.default) {
            (_) -> Void in
            guard let nameStr = alertController.textFields![0].text else { callBack?(nil); return }
            create(asset: nameStr) { isSuccess in
                guard isSuccess else { callBack?(nil); return }
                DataSingle.shared.myAlbums[nameStr] = Album(photos: [Photo](), name: nameStr, type: .local)
                AlbumHelper.insertLocalAlbum(with: nameStr)
                callBack?(nameStr)
            }
        })
        return alertController
    }
    static func insertLocalAlbum(with name: String) {
        DataBase.shared.insertLocalAlbum(with: name)
        DataSingle.shared.localAlbums.value.insert(name)
    }
    static func delectLocalAlbum(with names: [String]) {
        DataBase.shared.delectLocalAlbum(with: names)
        for name in names {
            DataSingle.shared.localAlbums.value.remove(name)
        }
    }
}

struct ApplicationMemoryCurrentUsage {
    var usage: Double = 0.0
    var total: Double = 0.0
    var ratio: Double = 0.0
}
extension AlbumHelper {
    static func report_memory() -> ApplicationMemoryCurrentUsage {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }

        if kerr == KERN_SUCCESS {
            //            print("Memory in use (in bytes): \(info.resident_size)")
            let usage = info.resident_size / (1024 * 1024)
            let total = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)
            let ratio = Double(usage) / Double(total)
            return ApplicationMemoryCurrentUsage(usage: Double(usage), total: Double(total), ratio: Double(ratio))
        } else {
            //            print("Error with task_info(): " +
            //                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
            return ApplicationMemoryCurrentUsage()
        }
    }
}
