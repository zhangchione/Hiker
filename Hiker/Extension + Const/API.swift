//
//  API.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/26.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation

// 基础url
let basicURL = "http://120.77.151.36:8080"
let testToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ2NoaW9uZSIsInBhc3N3b3JkIjoiemMxMjMuLi4iLCJpZCI6IjI2M2U2OGRkLTEwNzgtNGY4Ny05NDI3LTY0YTYzZDU4ZTEyNSIsImlhdCI6MTU3MDY5NzQ1NSwianRpIjoiNDZjNWM5NGEtMmVjOC00ZWMyLWExYzMtNjRmNWQzNDhhM2YzIiwidXNlcm5hbWUiOiJ6aGFuZ2NoaW9uZSJ9.enRAdmbJymGPQVvgsAhMR80UXyLA1CEWwwjmOfBcK6M"

func getLoginAPI(userID:String,password:String) -> String {
    let api = basicURL + "/login?username=" + userID + "&password=" + password
    return api
}
func getHomeAPI(page:Int) -> String {
    let api = basicURL + "/note/" + "\(page)" + "?token=" + getToken()!
    return api
}

func getMineAPI() -> String {
    let api = basicURL + "/user?token=" + getToken()!
    return api
}

func getImageAPI() -> String {
    return  "https://www.hut-idea.top/resources/upload"
}

func getStoryAPI() -> String {
    return basicURL + "/note/?token=" + getToken()!
}

func getNotesAPI() -> String {
    return basicURL + "/note/para?token=" + getToken()! 
}


func getSearchAPI(word:String) -> String {
    // encode编码
    let wod = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let api = basicURL + "/note/search?token=" + getToken()! + "&word=" + wod!
    return api
    
}


func getMyBookAPI() -> String {
    return basicURL + "/note/my/group?token=" + getToken()!
}

func getNewBookAPI() -> String {
    let api = basicURL + "/note/group/add?token=" + getToken()!
    return api
}

func getHiddenBookNameAPI() -> String  {
    return basicURL + "/note/group?token=" + getToken()!
}

func getFavAPI(noteId:Int)  -> String {
    return basicURL + "/note/like?token=" + getToken()! + "&noteId=" + "\(noteId)"
}

func getCollectedAPI(noteId:Int) -> String {
    return basicURL + "/note/collected?token=" + getToken()! + "&userId=" + getUserId()!
}

func getUserInfoAPI() -> String {
    return basicURL + "/user?token=" + getToken()!
}



