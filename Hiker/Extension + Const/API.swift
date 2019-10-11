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
//"http://images.tutuweb.cn:8888/api/v1/moments/upload"//
func getNotesAPI() -> String {
    return basicURL + "/note/para?token=" + getToken()! 
}

//http://120.77.151.36:8080/note/para?token= " " &content=33333&pics=23232&date=2019-10-11&place=%E9%95%BF%E6%B2%99&noteId=17

//eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ2NoaW9uZSIsInBhc3N3b3JkIjoiemMxMjMuLi4iLCJpZCI6IjI2M2U2OGRkLTEwNzgtNGY4Ny05NDI3LTY0YTYzZDU4ZTEyNSIsImlhdCI6MTU3MDY5NzQ1NSwianRpIjoiNDZjNWM5NGEtMmVjOC00ZWMyLWExYzMtNjRmNWQzNDhhM2YzIiwidXNlcm5hbWUiOiJ6aGFuZ2NoaW9uZSJ9.enRAdmbJymGPQVvgsAhMR80UXyLA1CEWwwjmOfBcK6M
//http://120.77.151.36:8080/note/para?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ2NoaW9uZSIsInBhc3N3b3JkIjoiemMxMjMuLi4iLCJpZCI6IjI2M2U2OGRkLTEwNzgtNGY4Ny05NDI3LTY0YTYzZDU4ZTEyNSIsImlhdCI6MTU3MDY5NzQ1NSwianRpIjoiNDZjNWM5NGEtMmVjOC00ZWMyLWExYzMtNjRmNWQzNDhhM2YzIiwidXNlcm5hbWUiOiJ6aGFuZ2NoaW9uZSJ9.enRAdmbJymGPQVvgsAhMR80UXyLA1CEWwwjmOfBcK6M&content=33333&pics=23232&date=2019-10-11&place=%E9%95%BF%E6%B2%99&noteId=17

