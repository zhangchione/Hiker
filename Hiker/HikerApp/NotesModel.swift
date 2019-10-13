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
    var notes = ""
    var fans = ""
    var concern = ""
}
struct Comments:HandyJSON {
    var id = ""
    var content = ""
    var user:User?
    var type = ""
    var pics = ""
}
struct NoteParas:HandyJSON {
    var id = ""
    var content = ""
    var pics = ""
    var place = ""
    var date = ""
    var noteid = ""
    var tags: [String]?
}


