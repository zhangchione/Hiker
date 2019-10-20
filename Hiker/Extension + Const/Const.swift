//
//  Const.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation

import Foundation
import UIKit


let kWhite       = UIColor.white
let kRed         = UIColor.red
let kOrange      = UIColor.orange
let kBlack       = UIColor.black
let kGreen       = UIColor.green
let kPurple      = UIColor.purple
let kBlue        = UIColor.blue


// iphone X
let isIphoneX = TKHeight == 812 ? true : false
// navigationBarHeight
let navigationBarHeight : CGFloat = isIphoneX ? 88 : 64
// tabBarHeight
let tabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49

// 屏幕宽高
let TKWidth = UIScreen.main.bounds.width
let TKHeight = UIScreen.main.bounds.height

// 背景色

@available(iOS 13.0, *)
let backColor = UIColor {(trait) -> UIColor in
    switch trait.userInterfaceStyle {
    case .light:
        return .white
    case .dark:
        return UIColor.init(r: 247, g: 247, b: 247)
    default:
        fatalError()
    }
}
    
// 文字色
let textColor = UIColor.init(r: 146, g: 146, b: 146)
// 底部状态栏背景色
let tabBarColor = UIColor.init(r: 151, g: 151, b: 151, alpha: 0.2)

// 自定义索引值
let kBaseTarget : Int = 1000
// 宽度比
let kWidthRatio = TKWidth / 414.0
// 高度比
let kHeightRatio = TKHeight / 896.0

// 自适应
func Adapt(_ value : CGFloat) -> CGFloat {
    
    return AdaptW(value)
}

// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    
    return ceil(value) * kWidthRatio
}

// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    
    return ceil(value) * kHeightRatio
}

// 常规字体
func FontSize(_ size : CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: AdaptW(size))
}

// 加粗字体
func BoldFontSize(_ size : CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: AdaptW(size))
}

