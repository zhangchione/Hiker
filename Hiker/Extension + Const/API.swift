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


func getRegisterAPI(userID:String,password:String) -> String {
    let api = basicURL + "/register?username=" + userID + "&password=" + password
    return api
}


func getLoginAPI(userID:String,password:String) -> String {
    let api = basicURL + "/login?username=" + userID + "&password=" + password
    return api
}

func getUserInfoAPI() -> String {
    return basicURL + "/user?token=" + getToken()!
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
func getImageAPIfast() -> String {
    return "http://images.huthelper.cn:8888/api/v1/moments/upload"
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


func getMyBookAPI(userId:String) -> String {
    return basicURL + "/note/my/group?token=" + getToken()! + "&userId=" + userId
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
func getUnFavAPI(noteId:Int)  -> String {
    return basicURL + "/note/like?token=" + getToken()! + "&noteId=" + "\(noteId)"
}

func getCollectedAPI(noteId:Int) -> String {
    return basicURL + "/note/collected?token=" + getToken()! //+ "&userId=" + getUserId()! + "&noteId" + "\(noteId)"
}

func getUnCollectedAPI(noteId:Int) -> String {
        return basicURL + "/note/collected?token=" + getToken()! 
}

func getCommentAPI() -> String {
    return basicURL + "/note/comment?token=" + getToken()!
}

func getAttentionAPI(userId:String) -> String {
    return basicURL + "/api/attention/v?token=" + getToken()! + "&id=" + userId
}

func getFansAPI(userId:String) -> String {
    
    return basicURL + "/api/attention?token=" + getToken()! + "&id=" + userId
}

func getToAttentionAPI() -> String{
    return basicURL + "/api/attention?token=" + getToken()!
}
func getUnAttentionAPI() -> String{
    return basicURL + "/api/attention?token=" + getToken()!
}


func getAlterUserInfoAPI() -> String {
    let api = basicURL + "/user?token=" + getToken()!
    return api
}


func getUserNotesAPI(userId:String) -> String {
    return basicURL + "/note/other?token=" + getToken()! + "&userId=" + userId
}

// 获取个人收藏
func getMyCollectionsAPI() -> String {
    let api  = basicURL + "/note/collected?token=" + getToken()!
    return api
}

// tags
func getTagsAPI() -> String {
    let api = basicURL + "/note/tag?token=" + getToken()!
    return api
}

// Delete游记

func getDeleteNoteAPI() -> String {
    let api = basicURL + "/note/?token=" + getToken()!
    return api
}

/*
 
 Mine token:
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ2NoaW9uZSIsInBhc3N3b3JkIjoiemMxMjMuLi4iLCJpZCI6IjI2M2U2OGRkLTEwNzgtNGY4Ny05NDI3LTY0YTYzZDU4ZTEyNSIsImlhdCI6MTU3MTExMDI0NSwianRpIjoiNzEyODBhMDItNDBlZi00MDc0LWIwOGItYTY1NzZiYTEzNzgwIiwidXNlcm5hbWUiOiJ6aGFuZ2NoaW9uZSJ9.prD9A6l-LEwwSspmdR8lPqzUAAJcsgxkEDPYW3tVlFY
 
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ2NoaW9uZSIsInBhc3N3b3JkIjoiemMxMjMuLi4iLCJpZCI6IjI2M2U2OGRkLTEwNzgtNGY4Ny05NDI3LTY0YTYzZDU4ZTEyNSIsImlhdCI6MTU3MDY5NzQ1NSwianRpIjoiNDZjNWM5NGEtMmVjOC00ZWMyLWExYzMtNjRmNWQzNDhhM2YzIiwidXNlcm5hbWUiOiJ6aGFuZ2NoaW9uZSJ9.enRAdmbJymGPQVvgsAhMR80UXyLA1CEWwwjmOfBcK6M
  ID:
263e68dd-1078-4f87-9427-64a63d58e125
 
 
 
 Jeffery Token
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJKZWZmZXJ5IiwicGFzc3dvcmQiOiIxMjM0NTYiLCJpZCI6IjA5ZGJhODVhLThiODYtNDQ2MC1hMWRkLWI3Njg0M2IxY2M1MyIsImlhdCI6MTU3MTAzNDU4OCwianRpIjoiYzdjYjRmMjQtOTRkMy00NmNkLWIwYjctOTcwZDQ4ZjJmYjIxIiwidXNlcm5hbWUiOiJKZWZmZXJ5In0.KItJWZ0arO0WxxdNo2ZCWVZkDQYbO8OVaMKd2glNxbs
 ID:
09dba85a-8b86-4460-a1dd-b76843b1cc53
 
 zc123
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6YzEyMyIsInBhc3N3b3JkIjoiMTIzNDU2IiwiaWQiOiIyMDg4M2JhMC0yZDQ3LTRiZTAtYWZlMS04MmVkOWVhNjI2ZmQiLCJpYXQiOjE1NzExMDA3NzksImp0aSI6IjI4MDg3MWE4LWUxNDgtNGIzOC1iOWIxLTJkNDc5ZTU3ZTMzMCIsInVzZXJuYW1lIjoiemMxMjMifQ._3yg-A3ZmpJF_QuUZrB4fX88yP5lrkrrKULmMyjli0I
 
 ID:
20883ba0-2d47-4be0-afe1-82ed9ea626fd
 **/
