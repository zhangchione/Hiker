//
//  DataSingle.swift
//  HikerImage
//
//  Created by 张驰 on 2019/10/17.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import RxSwift

class DataSingle {
    static let shared = DataSingle()

    var photos = [Photo]()// 全部相册
    var delectPhots = Variable([Photo]())  // 将要被删除的照片
    var hadDelectPhotos = Set<Photo>() // 已经被删除的照片
    var thingAlbums = [String: Album]()// 类型相册列表
    var locationAlbums = [String: Album]()// 位置相册列表
    var customAlbums = Variable([String: Album]())// 自定义相册列表
    var myAlbums = [String: Album]() // 系统本地全部相册列表
    var localAlbums = Variable(Set<String>())  //app中的本地相册名列表
}

// MARK: - Delete
extension DataSingle {
//    func deleteCustomAlbum(with names: [String]) {
//        for name in names {
//            customAlbums.value.removeValue(forKey: name)
//        }
//        DataBase.shared.deleteCustomAlbum(with: names)
//    }
}
