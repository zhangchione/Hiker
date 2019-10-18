//
//  PhotoDataManager.swift
//  HikerImage
//
//  Created by 张驰 on 2019/10/17.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import Photos
import CoreML
//import Lottie
import Vision
import ImageIO

protocol DataToEasyDelegate: class {
    func recognize(current: Int, max: Int)
}

class PhotoDataManager: NSObject {
    
    // MARK: Moudle
    weak var dataCenter: DataBase?
    let geocodeLocation = GeocodeLocation()
    var fetchPhotosResult = PHFetchResult<PHAsset>()
    var fetchAlbumsResult = PHFetchResult<PHCollection>()
    
    weak var dataToEasyDelegate: DataToEasyDelegate?
    
    
    
    // MARK: Config
    var configuration = PhotoDataManager.Configuration.default
    let photoSerialQueue = PhotoDataManager.PhotoSerialQueue()
    
    // MARK: State
    var current: Int = 0
    var max: Int = 0
    var isLoading = false
    let queue = OperationQueue()
    
    override init() {
        super.init()
        readPhoto()
        PHPhotoLibrary.shared().register(self)
        queue.maxConcurrentOperationCount = 3
        
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    func reloadEasyVC() {
        dataToEasyDelegate?.recognize(current: self.current, max: self.max)
    }
    
}
// MARK: 加载本地照片
extension PhotoDataManager {
    func readPhoto() {
        guard DataSingle.shared.photos.count == 0 && !isLoading else { return }
        isLoading = true
        loadLocalPhoto { [unowned self] in
            self.isLoading = false
            self.max = DataSingle.shared.photos.count
            let group = DispatchGroup()
            let workItem = DispatchWorkItem { self.recognizeLocalThing() }
            self.photoSerialQueue.thing.async(execute: workItem) // 从本地数据库读取类型
            self.photoSerialQueue.my.async { self.loadLocalAlbum();  } // 读取本地my相册
            self.photoSerialQueue.thing.async {self.recognizeModelThing()} // 从模型读取类型
            group.enter()
            self.photoSerialQueue.location.async { workItem.wait(); self.recognizeLocation(); group.leave() }
            //加载自定义
            group.notify(queue: self.photoSerialQueue.custom, execute: {
                self.loadCustomAlbum()
                self.reloadEasyVC()
            })
        }
    }
        
}
fileprivate extension PhotoDataManager {
    func detectionModel() {
        let modelVersion = "\(configuration.modelVersion)"
        //        if UserDefaults.standard.string(forKey: "model") == "justin" {
        //            configuration = PhotoDataManager.Configuration.justin
        //        }
        guard UserDefaults.standard.string(forKey: "modelVersion") != modelVersion  else { return }
        //        try? FileManager.default.removeItem(at: URL.init(fileURLWithPath: DataCenterConstant.dbFilePath))
        //        UserDefaults.standard.set(modelVersion, forKey: "modelVersion")
    }

    func loadLocalAlbum() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized { return  }
            let fetchCvResult = PHCollectionList.fetchTopLevelUserCollections(with: nil) //用户所有的相册
            self.fetchAlbumsResult = fetchCvResult
            for i in 0..<self.fetchAlbumsResult.count {
                guard let c = self.fetchAlbumsResult[i] as? PHAssetCollection else { continue }
                self.fetchAlbums(in: c)
            }
//            self.dataToMyDelegate?.reloadMyVC()
            self.loadAppLocalAlbum()
        })
    }

    func loadAppLocalAlbum() {
        DataSingle.shared.localAlbums.value = Set(DataBase.shared.querylocalAlbumName())
    }

    func loadLocalPhoto(finfish: (() -> Void)?) {
        PHPhotoLibrary.requestAuthorization({ (status) in
            guard status == .authorized else { return }
            let options = PHFetchOptions()
            options.config()
            let delectPhotos = DataBase.shared.queryDelectPhoto()
            PHPhotoLibrary.shared().performChanges({
                self.fetchPhotosResult = PHAsset.fetchAssets(with: options)
                self.fetchPhotosResult.enumerateObjects({ (asset, _, _) in
                    // 如果是图片类型则加载
                    if asset.mediaType == .image {
                        DataSingle.shared.photos.append(Photo(asset))
                    }
                    // 加载删除列表照片
                    if delectPhotos.contains(asset.localIdentifier) {
                        DataSingle.shared.delectPhots.value.append(Photo.init(asset))
                    }
                })
            }) { _, _ in
                finfish?()
            }
        })
    }

    func addThingAlbum(_ photo: Photo, by confidence: Float) {
        var label = "other"
        if let l = photo.identifiers?.first?.0, let photoConfidence = photo.identifiers?.first?.1, Float(photoConfidence) > confidence {
            label = l
        }
        if  DataSingle.shared.thingAlbums[label] == nil {
            DataSingle.shared.thingAlbums[label] = Album(photos: [photo], name: label, propertys: [.things([label])], type: .thing)
        } else {
            DataSingle.shared.thingAlbums[label]!.photos.append(photo)
        }
    }

    func addCustomAlbum(_ photo: Photo, with name: String, property: [AlbumProperty]) {
        if DataSingle.shared.customAlbums.value[name] == nil {
            DataSingle.shared.customAlbums.value[name] = Album(photos: [photo], name: name, propertys: property, type: .custom)
        } else {
            DataSingle.shared.customAlbums.value[name]!.photos.append(photo)
        }
    }

    func addMyAlbum(_ photo: Photo, with name: String?, uniqueSet: Set<Photo>?) {
        guard let name = name else { return }
        if DataSingle.shared.myAlbums[name] == nil {
            DataSingle.shared.myAlbums[name] = Album(photos: [photo], name: name, type: .local)
        } else if let set = uniqueSet {
            if set.contains(photo) { return }
            DataSingle.shared.myAlbums[name]!.photos.append(photo)
        } else {
            DataSingle.shared.myAlbums[name]!.photos.append(photo)
        }
    }

}

extension PhotoDataManager {
    func fetchAlbums(in c: PHAssetCollection, needUnique: Bool = false) {
        let options = PHFetchOptions()
        options.config()
        let myFetchResult = PHAsset.fetchAssets(in: c, options: options)
        var uniqueSet: Set<Photo>?
        if let name = c.localizedTitle, needUnique, let photos = DataSingle.shared.myAlbums[name]?.photos {
            uniqueSet = Set(photos)
        }
        myFetchResult.enumerateObjects { (asset, _, _) in
            self.addMyAlbum(Photo(asset), with: c.localizedTitle, uniqueSet: uniqueSet)
        }
        // 空相册
        if myFetchResult.count == 0, let name = c.localizedTitle {
            DataSingle.shared.myAlbums[name] = Album(photos: [Photo](), name: name, type: .local)
        }
    }

    static func addLocationAlbum(_ photo: Photo) {
        guard let label = photo.city, label != "" else { return }
        if  DataSingle.shared.locationAlbums[label] == nil {
            DataSingle.shared.locationAlbums[label] =  Album(photos: [photo], name: label, propertys: [.location([label])], type: .location)
        } else {
            DataSingle.shared.locationAlbums[label]!.photos.append(photo)
        }
    }
}

// MARK: Fileprivate Tool Method
fileprivate extension PhotoDataManager {
    func recognizeLocalThing() {
        DataSingle.shared.photos.forEach { photo in
            if DataBase.shared.findPhoto(with: photo) {
                self.addThingAlbum(photo, by: configuration.confidence)
                current += 1
                reloadEasyVC()
                if self.max - self.current < 10 {
                    //self.reloadMyVC()
                }
            }
        }
    }
    func recognizeModelThing() {
        DataSingle.shared.photos.forEach { photo in
            if photo.identifiers == nil {
                self.queue.addOperation {
                    RecognizeUtil.startRecognize(photo, with: self.configuration.coreMLModel) { [unowned self] in
                        self.addThingAlbum(photo, by: self.configuration.confidence)
                        DataBase.shared.insertThingIndex(with: photo)
                        self.current += 1
                        self.reloadEasyVC()
                        if self.max - self.current < 10 {
                            //self.reloadMyVC()
                        }
                    }
                }
            }
        }
    }
    func recognizeLocation() {
        DataSingle.shared.photos.forEach { photo in
            guard photo.location != nil else { return }
            if let city = DataBase.shared.queryLocation(with: photo) {
                photo.city = city
                DataBase.shared.insertLocation(with: city)
                PhotoDataManager.addLocationAlbum(photo)
            } else if let city = DataBase.shared.queryLocationByGeographic(with: photo) {
                photo.city = city
                PhotoDataManager.addLocationAlbum(photo)
            } else {
                geocodeLocation.waitPhoto.append(photo)
            }
        }
        geocodeLocation.startGeocode()
    }

    func loadCustomAlbum() {
        let customs = DataBase.shared.queryCustomPhoto()
        for custom in customs {
            DataSingle.shared.photos.forEach { photo in
                guard self.isCustom(photo: photo, with: custom) else { return }
                let name = custom.name
                var property = [AlbumProperty]()
                if let things = custom.thingsChoice {
                    property.append(.things(things))
                }
                if let locations = custom.locationChoice {
                    property.append(.location(locations))
                }
                if custom.beginTime != nil || custom.endTime != nil {
                    property.append(.time(start: custom.beginTime, end: custom.endTime))
                }
                addCustomAlbum(photo, with: name, property: property)
            }
        }
    }
}
