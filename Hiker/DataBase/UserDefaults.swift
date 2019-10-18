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
func saveUserId(userId:String){
    defaults.set(userId, forKey: "userid")
    defaults.synchronize()
}
func getUserId() -> String? {
    return defaults.string(forKey: "userid")
}
func saveHeadPic(headPic:String){
    defaults.set(headPic, forKey: "headpic")
    defaults.synchronize()
}
func getHeadPic() -> String? {
    return defaults.string(forKey: "headpic")
}
func saveNickName(nickName:String){
    defaults.set(nickName, forKey: "nickname")
    defaults.synchronize()
}
func getNickName() -> String? {
    return defaults.string(forKey: "nickname")
}

func saveFlag(flag:String){
    defaults.set(flag, forKey: "flag")
    defaults.synchronize()
}
func getFlag() -> String? {
    return  defaults.string(forKey: "flag")
}
//游记标题

func saveTitle(title:String) {
    defaults.set(title,forKey: "title")
    defaults.synchronize()
}

func getTitle() -> String? {
    
    return defaults.string(forKey: "title")
}


func saveHistory1(history1:String) {
    defaults.set(history1,forKey: "history1")
    defaults.synchronize()
}

func getHistory1() -> String? {
    return defaults.string(forKey: "history1")
}
func saveHistory2(history2:String) {
    defaults.set(history2,forKey: "history2")
    defaults.synchronize()
}
func getHistory2() -> String? {
    return defaults.string(forKey: "history2")
}


func saveBookName(bookname:[String]) {
    defaults.set(bookname,forKey: "bookname")
    defaults.synchronize()
}
func getBookName() -> [String]? {
    let content = defaults.object(forKey: "bookname") as? [String]
    return content
}
func saveBookId(bookname:[Int]) {
    defaults.set(bookname,forKey: "bookid")
    defaults.synchronize()
}
func getBookId() -> [Int]? {
    let content = defaults.object(forKey: "bookid") as? [Int]
    return content
}
func saveBookNum(bookname:[Int]) {
    defaults.set(bookname,forKey: "booknum")
    defaults.synchronize()
}

func getBookNum() -> [Int]? {
    let content = defaults.object(forKey: "booknum") as? [Int]
    return content
}

func saveContent(content:[String]) {
    print("存储内容为:",content)
    defaults.set(content,forKey: "content")
    defaults.synchronize()
}
func getContent() -> [String]? {
    let content = defaults.object(forKey: "content") as? [String]
    return content
}

func saveLocation(location:[String]) {
    print("地点为：",location)
    defaults.set(location,forKey: "location")
    defaults.synchronize()
}
func getLocation() -> [String]? {
    
    return defaults.object(forKey: "location") as? [String]
}

func saveTime(content:[String]) {
    defaults.set(content,forKey: "time")
    defaults.synchronize()
}
func getTime() -> [String]? {
    
    return defaults.object(forKey: "time") as? [String]
}

func savePic(content:[String]) {
    defaults.set(content,forKey: "pic")
    defaults.synchronize()
}
func getPic() -> [String]? {
    
    return defaults.object(forKey: "pic") as? [String]
}

func saveImgs(datas:Array<Array<Data>>) {
    defaults.set(datas,forKey:"imgs")
    defaults.synchronize()
}

func getImgs() -> [[Data]] {
    return defaults.object(forKey: "imgs") as! [[Data]]
}





func saveNotes(notes:[Notes]) {
    var notesArray = Array<Data>()
    
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
    let notes  = defaults.object(forKey: "notes") as? [Data]
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


