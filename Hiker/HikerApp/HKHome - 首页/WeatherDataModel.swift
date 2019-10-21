//
//  WeatherDataModel.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/21.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import UIKit
class WeatherDataModel {
    
    //Declare your model variables here
    var temperature: Int = 0
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var isTracking = false
    var user_img = "home_img_user"
    var back_img = "home_img_back"
    var weatherDescribe = "晴转多云"
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sun1"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
}

