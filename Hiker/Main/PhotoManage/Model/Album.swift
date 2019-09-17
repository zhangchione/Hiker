//
//  Album.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/17.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import ObjectMapper

enum AlbumType {
    case thing
    case location
    case custom
    case local
}

enum AlbumProperty {
    case things([String])
    case location([String])
    case time(start: Date?, end: Date?)
}

class Album {
    var photos = [Photo]()
    var type: AlbumType
    var name: String
    var propertys: [AlbumProperty]
    //    var custom: String?
    //    var things: String?
    //    var location: String?
    
    var createTime: Date?
    init(photos: [Photo]?, name: String, propertys: [AlbumProperty] = [AlbumProperty](), type: AlbumType, createTime: Date? = Date()) {
        self.type = type
        self.name = name
        self.propertys = propertys
        if let photos = photos {
            self.photos = photos
        }
        self.createTime = createTime
    }
    
    var key: String {
        return name
    }
}

extension Album: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Album(photos: photos, name: name, propertys: propertys, type: type)
    }
}
extension Album: Equatable {
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.key == rhs.key
    }
}

extension Album: Hashable {
    public func hash(into hasher: inout Hasher) {
        if key == "" {
            hasher.combine(createTime.hashValue)
        } else {
            hasher.combine(key.hashValue)
        }
    }
}



struct NewAlbum {
    var name: String
    var thingsChoice: [String]?
    var locationChoice: [String]?
    var beginTime: Date?
    var endTime: Date?
    init(name: String, classifyChoice: [String]?, locationChoice: [String]?, beginTime: Date?, endTime: Date?) {
        self.name = name
        self.thingsChoice = classifyChoice
        self.locationChoice = locationChoice
        self.beginTime = beginTime
        self.endTime = endTime
    }
}

extension NewAlbum: Mappable {
    init?(map: Map) {
        name = ""
        mapping(map: map)
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        name           <- map["name"]
        thingsChoice   <- map["thingsChoice"]
        locationChoice   <- map["locationChoice"]
        beginTime <- (map["beginTime"], DateTransform())
        endTime <- (map["endTime"], DateTransform())
    }
}
