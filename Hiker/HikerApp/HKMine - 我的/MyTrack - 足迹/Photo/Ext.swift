//
//  DefaultsKeys+Ext.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension Zephyr {
    static let keys = [DefaultsKeys.locationAlbumsKey, DefaultsKeys.customAlbumsKey, DefaultsKeys.syncTimeKey]
    static func syncEasyToiCloud() {
        Zephyr.shared.syncSpecificKeys(keys: keys, dataStore: .local)
    }
    static func syncEasyFromiCloud() {
        Zephyr.shared.syncSpecificKeys(keys: keys, dataStore: .remote)
    }
}

// MARK: - DefaultsKeys
extension DefaultsKeys {
    static let customAlbumsKey = "cc.zc.track.customAlbums"
    static let locationAlbumsKey = "cc.zc.track.locationAlbums"
    static let syncTimeKey = "cc.zc.track.syncTime"
    /// 备份时间
    static let syncTime = DefaultsKey<Date?>(DefaultsKeys.syncTimeKey)
    /// 本地相册列表
    static let locationAlbums = DefaultsKey<[String]?>(DefaultsKeys.locationAlbumsKey)
    /// 自定义相册列表
    static let customAlbums = DefaultsKey<[String]?>(DefaultsKeys.customAlbumsKey)
    /// 是否首次启动
    static let isFirstRun = DefaultsKey<Bool>("cc.zc.track.isFirstRun", defaultValue: false)
    //    static let hasSetSalary = DefaultsKey<Bool>("icu.user.info.has.set.salary", defaultValue: false)
}

extension CGFloat {
    var fitScreen: CGFloat {
        return CGFloat(self/414.0 * UIScreen.main.bounds.size.width)
    }
}
extension CGRect {
    var fit: CGRect {
        return CGRect(x: self.minX.fitScreen, y: self.minY.fitScreen, width: self.width.fitScreen, height: self.height.fitScreen)
    }
}
extension CGSize {
    var fit: CGSize {
        return CGSize(width: self.width.fitScreen, height: self.height.fitScreen)
    }
}
extension Double {
    var fit: CGFloat {
        return CGFloat(self/414.0) * UIScreen.main.bounds.width
    }
}
extension Int {
    var fit: Int {
        return Int(CGFloat(self)/414.0 * UIScreen.main.bounds.width)
    }
}
extension UIColor {
    convenience   init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience   init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIScreen {
    var titleY: CGFloat {
        if safeAreaInsets.top == 0 {
            return 20.0
        } else {
            return safeAreaInsets.top
        }
    }
    
    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return  UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        } else {
            return .zero
            // Fallback on earlier versions
        }
    }
    
    func widthOfSafeArea() -> CGFloat {
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        if #available(iOS 11.0, *) {
            let leftInset = rootView.safeAreaInsets.left
            let rightInset = rootView.safeAreaInsets.right
            return rootView.bounds.width - leftInset - rightInset
        } else {
            return rootView.bounds.width
        }
    }
    
    func heightOfSafeArea() -> CGFloat {
        
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        
        if #available(iOS 11.0, *) {
            
            let topInset = rootView.safeAreaInsets.top
            
            let bottomInset = rootView.safeAreaInsets.bottom
            
            return rootView.bounds.height - topInset - bottomInset
            
        } else {
            
            return rootView.bounds.height
            
        }
        
    }
    
}
