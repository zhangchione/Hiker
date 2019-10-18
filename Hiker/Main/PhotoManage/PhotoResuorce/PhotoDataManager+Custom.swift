//
//  RecognizeManager+Custom.swift
//  Recognize
//
//  Created by nine on 2018/9/20.
//

import Foundation
import Photos


extension PhotoDataManager {
    // 新建一个自定义相册，遍历内存中的照片
    func addCustomAlbum(condition: NewAlbum) -> [Photo]? {
        var newPhotos: [Photo]?
        newPhotos =  DataSingle.shared.photos.filter({ (p) -> Bool in
            return self.isCustom(photo: p, with: condition)
        })
        guard newPhotos!.count > 0 else {
           // self.dataToEasyDelegate?.showSuccess("没有符合要求的相册")
            return nil
        }
        let name = condition.name

        guard DataSingle.shared.customAlbums.value[name] == nil else {
           // self.dataToEasyDelegate?.showError("\(name)相册已经存在")
            return nil
        }
        // 加载条件
        var property = [AlbumProperty]()
        if let things = condition.thingsChoice {
            property.append(.things(things))
        }
        if let locations = condition.locationChoice {
            property.append(.location(locations))
        }
        if condition.beginTime != nil || condition.endTime != nil {
            property.append(.time(start: condition.beginTime, end: condition.endTime))
        }
        
        return newPhotos
//        DataSingle.shared.customAlbums.value[name] = Album(photos: newPhotos, name: name, propertys: property, type: .custom)
        
        if let json = condition.toJSONString() {
//            if Defaults[.customAlbums] == nil {
//                Defaults[.customAlbums] = []
//            }
//            Defaults[.customAlbums]!.append(json)
//            Zephyr.syncEasyToiCloud()
        }
        
//        DataBase.shared.insertCustomPhoto(with: condition)
      
    }

    func isCustom(photo p: Photo, with condition: NewAlbum) -> Bool {
        var location = true
        var category = true
        var beginTime = true
        var endTime = true
        // 分类
        if let classifyChoices = condition.thingsChoice, classifyChoices.count > 0 {
            guard let classify = p.identifiers?.first?.0, let confidence = p.identifiers?.first?.1 else { return false }
            category = classifyChoices.contains(classify) && confidence > configuration.confidence
        }
        // 位置
        if let locationChoices = condition.locationChoice, locationChoices.count > 0 {
            guard let l = p.city else { return false }
            location = locationChoices.contains(l)
        }
        // 开始时间
        if let begin = condition.beginTime, let pBeginTime = p.createTime {
            beginTime = pBeginTime >= begin
        }
        // 结束
        if let end = condition.endTime, let pEndTime = p.createTime {
            endTime = pEndTime <= end
        }
        return location && category && beginTime && endTime
    }
}

extension PhotoDataManager {
        // 新建一个自定义相册，遍历内存中的照片
        func addCustomAlbum1(condition: NewAlbum) -> [Photo]? {
            let newPhotos =  DataSingle.shared.photos.filter({ (p) -> Bool in
                return self.isCustom(photo: p, with: condition)
            })
            guard newPhotos.count > 0 else {
               // self.dataToEasyDelegate?.showSuccess("没有符合要求的相册")
                return nil
            }
            let name = condition.name

            guard DataSingle.shared.customAlbums.value[name] == nil else {
               // self.dataToEasyDelegate?.showError("\(name)相册已经存在")
                return nil
            }
            // 加载条件
            var property = [AlbumProperty]()
            if let things = condition.thingsChoice {
                property.append(.things(things))
            }
            if let locations = condition.locationChoice {
                property.append(.location(locations))
            }
            if condition.beginTime != nil || condition.endTime != nil {
                property.append(.time(start: condition.beginTime, end: condition.endTime))
            }
            
            return newPhotos
    //        DataSingle.shared.customAlbums.value[name] = Album(photos: newPhotos, name: name, propertys: property, type: .custom)
            
            if let json = condition.toJSONString() {
    //            if Defaults[.customAlbums] == nil {
    //                Defaults[.customAlbums] = []
    //            }
    //            Defaults[.customAlbums]!.append(json)
    //            Zephyr.syncEasyToiCloud()
            }
            
    //        DataBase.shared.insertCustomPhoto(with: condition)
          
        }

        func isCustom1(photo p: Photo, with condition: NewAlbum) -> Bool {
            var location = true
       //     var category = true
            var beginTime = true
            var endTime = true
            // 位置
            if let locationChoices = condition.locationChoice, locationChoices.count > 0 {
                guard let l = p.city else { return false }
                location = locationChoices.contains(l)
            }
            // 开始时间
            if let begin = condition.beginTime, let pBeginTime = p.createTime {
                beginTime = pBeginTime >= begin
            }
            // 结束
            if let end = condition.endTime, let pEndTime = p.createTime {
                endTime = pEndTime <= end
            }
            return location  && beginTime && endTime
        }
}
