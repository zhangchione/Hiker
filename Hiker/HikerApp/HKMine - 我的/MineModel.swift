//
//  MineModel.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/25.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import HandyJSON

struct ConcernsModel:HandyJSON {
    var code:String?
    var data: [User]?
    var msg:String?
}
struct FansModel:HandyJSON {
    var code:String?
    var data: [User]?
    var msg:String?
}

struct MineModel:HandyJSON {
    var code:String?
    var data: UserModel?
    var msg:String?
}
struct UserModel:HandyJSON {
    var id = ""
    var userid = ""
    var password = ""
    var username = "王一一"
    var sgin = "爱旅行,爱旅拍的校长同学"
    var notes = 0
    var headPic = "head1"
    var fans = 0
    var concern = 0
    var nickName = ""
    var bgPic = ""
}
//struct Fan:HandyJSON {
//    var isconcern = false
//    var user:MineUser?
//}
//struct Concern:HandyJSON {
//    var isconcern = false
//    var user:MineUser?
//}
struct MineUser:HandyJSON {
    var id = ""
    var userid = ""
    var username = ""
    var sgin = ""
    var password = ""
    var headPic = ""
}


