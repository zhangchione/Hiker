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
func getHomeAPI(page:String) -> String {
    let api = basicURL + "/note/" + page + "?token=" + getToken()!
    return api
}
