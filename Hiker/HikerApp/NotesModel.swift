//
//  NotesModel.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/23.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import HandyJSON

/// 故事簿
struct HKStory:HandyJSON {
    var msg:String?
    var code:Int?
    var data:[StoryModel]?
}
struct StoryModel:HandyJSON {
    var bookName = ""
    var story:[NotesModel]?
    var id = 0
}

struct HKUser:HandyJSON {
    var user:User?
    var data: [NotesModel]?

}
/// City

struct City {
    var title:String?
    var img:String?
}

struct HKCity:HandyJSON {
    var msg:String?
    var code:String?
    var data:[CityModel]?
}

struct CityModel:HandyJSON {
    var citypic = ""
    var cityname = ""
    var story:[NotesModel]?
}

struct HomeModel: HandyJSON {
    var msg:String?
    var code:String?
    var data:[NotesModel]?
}

struct NotesModel:HandyJSON {
    var id = 0
    var content = ""
    var user:User?
    var type = 0
    var pics: [String]?
   // var time = ""
   // var locations: [String]?
    var comments:[Comments]?
    var title = ""
    var likes = 0
    var like = false
    var collected = false
    var noteParas:[NoteParas]?
    var hidden = 0
}
struct User:HandyJSON {
    var id = ""
    var username = ""
    var password = ""
    var headPic = ""
    var sgin = ""
    var notes = 0
    var fans = 0
    var concern = 0
    var nickName = ""
    var bgPic = ""
}

struct Comments:HandyJSON {
    var id = 0
    var content = ""
    var user:User?
    var type = 0
    var pics = ""
    var time = ""
}
struct NoteParas:HandyJSON {
    var id = ""
    var content = ""
    var pics = ""
    var place = ""
    var date = ""
    var noteid = ""
    var tags: [Tags]?
}
struct Tags:HandyJSON {
    var id = ""
    var name = ""
    var paraId = 0
}


