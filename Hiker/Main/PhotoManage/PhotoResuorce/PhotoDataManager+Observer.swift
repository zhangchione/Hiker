//
//  PhotoDataManager+Observer.swift
//  PhotoResource
//
//  Created by nine on 2018/12/20.
//

import Foundation
import Photos

// static
extension PhotoDataManager {
    static func removeAllDelectPhotos() {
        DataSingle.shared.delectPhots.value.removeAll()
        DataBase.shared.deleteAllDelectTable()
    }
    static func removeDelect(photos: [Photo]) {
        let assets = photos.map { $0.asset.localIdentifier }
        // 移除内存中的删除
        DataSingle.shared.delectPhots.value.removeAll(where: { p in  assets.contains(p.asset.localIdentifier) })
        // 移除本地
        DataBase.shared.delectDeleteTable(with: photos)
    }
    static func addDelect(photos: [Photo]) {
        photos.forEach { (p) in
            // 保存到内存
            DataSingle.shared.delectPhots.value.append(p)
            // 保存到本地
            DataBase.shared.insertDelect(with: p)
        }
    }

    static func isDelected(with photos: Photo) -> Bool {
        return DataSingle.shared.delectPhots.value.first(where: { p in p == photos}) != nil
        //        photos.forEach { (p) in
        //            // 保存到内存
        //            DataSingle.shared.delectPhots.value.append(p)
        //            // 保存到本地
        //            DataCenter.shared.insertDelect(with: p)
        //        }
    }

    static func delete(_ photos: [Photo]) {
        //        delect(photo, inAlbums: [DataSingle.shared.thingAlbums, DataSingle.shared.locationAlbums, DataSingle.shared.customAlbums, DataSingle.shared.myAlbums])
        //        DataSingle.shared.photos.enumerated().forEach { (index, p) in
        //            if photo.asset.localIdentifier == p.asset.localIdentifier {
        //                DataSingle.shared.photos.remove(at: index)
        //            }
        //        }
        // 加入到内存已经删除中
        for p in photos {
            DataSingle.shared.hadDelectPhotos.insert(p)
        }
        // 删除数据库中的保存
        DispatchQueue.global(qos: .background).async {
            DataBase.shared.delectDeleteTable(with: photos)
        }
        // 移除内存中的删除
        let localAssetIds = photos.map { $0.asset.localIdentifier }
        DataSingle.shared.delectPhots.value.removeAll(where: { p in localAssetIds.contains(p.asset.localIdentifier) })
    }
    static private func delect(_ photo: Photo, inAlbums albums: [[String: Album]]) {
        albums.forEach { album in
            album.forEach { (a) in
                if let p = a.value.photos.firstIndex(where: { (p) -> Bool in
                    return p.asset.localIdentifier == photo.asset.localIdentifier
                }) {
                    a.value.photos.remove(at: p)
                }
            }
        }
    }

}

extension PhotoDataManager: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // 相册
        if let changes = changeInstance.changeDetails(for: fetchAlbumsResult), changes.hasIncrementalChanges {
            albumsDidChange(changes)
        }
        // 照片
        if let changes = changeInstance.changeDetails(for: fetchPhotosResult), changes.hasIncrementalChanges {
            photosDidChange(changes)
        }
//        reloadEasyVC()
//        dataToMyDelegate?.reloadMyVC()
//        dataToPhotosDelegate?.reloadPhotosVC()
    }
}

extension PhotoDataManager {
    private func albumsDidChange(_ changes: PHFetchResultChangeDetails<PHCollection>) {
        fetchAlbumsResult = changes.fetchResultAfterChanges
        let removed = changes.removedObjects
        if removed.count > 0 {
            for i in 0..<removed.count {
                guard let c = removed[i] as? PHAssetCollection, let title = c.localizedTitle else { continue }
                DataSingle.shared.myAlbums.removeValue(forKey: title)
            }
        }
        let inserted = changes.insertedObjects
        if inserted.count > 0 {
            for i in 0..<inserted.count {
                guard let c = inserted[i] as? PHAssetCollection else { continue }
                //self.fetchAlbums(in: c, needUnique: true)
            }
        }
        let changed = changes.changedObjects
        if  changed.count > 0 {
            for i in 0..<changed.count {
                guard let c = changed[i] as? PHAssetCollection else { continue }
                //self.fetchAlbums(in: c, needUnique: true)
            }
        }
    }

    private func photosDidChange(_ changes: PHFetchResultChangeDetails<PHAsset>) {
        fetchPhotosResult = changes.fetchResultAfterChanges
        let removed = changes.removedObjects
        if  removed.count > 0 {
            //            let removeIds = removed.map { $0.localIdentifier }
            let removes = removed.map { Photo($0) }
            PhotoDataManager.delete(removes)
        }
        let inserted = changes.insertedObjects
        if inserted.count > 0 {
            for asset in inserted {
                DataSingle.shared.photos.append(Photo(asset))
            }
        }
        let changed = changes.changedObjects
        if  changed.count > 0, changed.count < 10 {
            DispatchQueue.global(qos: .background).async {
                DataSingle.shared.photos.forEach { photo in
                    for changeAsset in changed where photo.asset.localIdentifier == changeAsset.localIdentifier {
                        photo.asset = changeAsset
                    }
                }
            }
        }

    }
}
