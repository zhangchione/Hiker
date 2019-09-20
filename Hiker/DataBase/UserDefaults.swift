//
//  UserDefaults.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/20.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation

fileprivate let defaults = UserDefaults.standard

func saveToken(token:String){
    defaults.set(token, forKey: "token")
    defaults.synchronize()
}
func getToken() -> String? {
    return  defaults.string(forKey: "token")
}


//游记标题

func saveTitle(title:String) {
    defaults.set(title,forKey: "title")
    defaults.synchronize()
}

func getTitle() -> String? {
    
    return defaults.string(forKey: "title")
}

// 游记内容
struct note {
    var content = ""
    var location = ""
    var time = ""
    var pic = [String]()
}


func saveNotes(notes:[note]) {
    defaults.set(notes,forKey:"notes")
    defaults.synchronize()
}
func getNotes() -> [note]? {
    return defaults.array(forKey: "notes") as? [note]
}



