//
//  API.swift
//  Hiker
//
//  Created by 张驰 on 2020/1/4.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation

import Moya


public enum LoginAPI{
    case login(String,String)
    case register(String,String)
}

extension LoginAPI: TargetType{
    public var baseURL: URL {
        return URL(string:basicURL)!
    }
    
    public var path: String {
        switch self{
        case .login(let id,let pwd):
            return "/login?username=\(id)&password=\(pwd)"
        case .register(_, _):
            return "1"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        return .requestParameters(parameters: ["1":"1"], encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}

