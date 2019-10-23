//
//  Photo.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/17.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import Photos
import DifferenceKit

class Photo {
    var asset: PHAsset
    var identifiers: [(String, Float)]?
    var city: String?
    var location: CLLocation? {
        return asset.location
        
    }
    var createTime: Date? {
        return asset.creationDate
    }
    init(_ asset: PHAsset, _ identifier: [(String, Float)]? = nil, _ locationStr: String? = nil) {
        self.asset = asset
        self.identifiers = identifier
        self.city = locationStr
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.asset.localIdentifier == rhs.asset.localIdentifier
    }
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(asset.localIdentifier)
    }
}

extension Photo: Differentiable {}
