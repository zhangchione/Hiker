//
//  PhotoBannerViewModel.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import Photos
import UIKit
class PhotoBannerViewModel {
    let album: Album
    var image: UIImage?
    var saved: Bool {
        return (assetAlbum() != nil && DataSingle.shared.localAlbums.value.contains(album.name))
    }

    var delectCallBack: (() -> Void)?
    var saveCallBack: (() -> Void)?
    var backCallBack: (() -> Void)?
    var removeCallBack: (() -> Void)?
    init(with album: Album) {
        self.album = album
    }

    func bannerDescribeText() -> String {
        var res = ""
        for propertys in album.propertys {
            switch propertys {
            case .things(let things):
                res += things.reduce("", { x, y in
                    return x == "" ? y : x + "、" + y
                })
            case .location(let location):
                res += (res == "" ? "" : " | ")
                res += location.reduce("", { x, y in
                    return x == "" ? y : x + "、" + y
                })
            case .time(let start, let end):
                res += (res == "" ? "" : " | ")
                var startStr = "before"
                if let start = start {
                    startStr = start.string(withFormat: "yyyy.mm.dd")
                }
                res += startStr
                res += "-"
                var endStr = "now"
                if let end = end {
                    endStr = end.string(withFormat: "yyyy.mm.dd")
                }
                res += endStr
            }
        }
        res += (res == "" ? "" : " | ")
        res += "\(album.photos.count)张"
        return res
    }

    func assetAlbum() -> PHAssetCollection? {
        return AlbumHelper.findAlbum(with: album.name)
    }
}
