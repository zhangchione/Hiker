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


func saveNotes(notes:[Notes]) {
    var notesArray = Array<Any>()
    
    for note in notes {
        let data = NSKeyedArchiver.archivedData(withRootObject: note)
        notesArray.append(data)
        print(notes)
    }
    defaults.set(notesArray,forKey:"notes")
    defaults.synchronize()
    print("存储成功")
}
func getNotes() -> [Notes]? {
    let notes  = defaults.array(forKey: "notes")
    var arrays: [Notes]?
    if notes != nil {
        for note in notes! {
            let array = NSKeyedUnarchiver.unarchiveObject(with: note as! Data) as! Notes
            arrays?.append(array)
            print(array)
        }
    }
    print("放回成功")
    return arrays
}


class Notes: NSObject,NSCoding {
    var content:String
    var location:String
    var time:String
    var pic:String
    
    
    required  init(content:String = "",location:String = "",time:String = "",pic:String = "") {
        self.content = content
        self.location = location
        self.time = time
        self.pic = pic
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content,forKey: "Content")
        aCoder.encode(location,forKey: "Location")
        aCoder.encode(time,forKey: "Time")
        aCoder.encode(pic,forKey: "Pic")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.content = aDecoder.decodeObject(forKey: "Content") as? String ?? ""
        self.location = aDecoder.decodeObject(forKey: "Location") as? String ?? ""
        self.time = aDecoder.decodeObject(forKey: "Time") as? String ?? ""
        self.pic = aDecoder.decodeObject(forKey: "Pic") as? String ?? ""
    }
    

    

}


