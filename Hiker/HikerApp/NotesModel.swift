//
//  NotesModel.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/23.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation

struct NotesModel {
    var id = ""
    var title = ""
    var pics = ""
    var likes = 0
    var liked = false
    var collected = false
    var user:User?
    var comments:Comments?
    var notePares:NoteParas?
}
struct User {
    var user_img = ""
    var user_name = ""
    var user_id = ""
}
struct Comments {
    var id = ""
    var content = ""
    var user:User?
    var type = ""
    var pics = ""
}
struct NoteParas {
    var id = ""
    var content = ""
    var pic = ""
    var place = ""
    var date = ""
    var noteid = ""
}


