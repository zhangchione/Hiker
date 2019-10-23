//
//  HKHomeController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/21.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import LTScrollView
import SnapKit
import Alamofire
import HandyJSON
import SwiftyJSON
import ProgressHUD
import MJRefresh
import Kingfisher
import CoreLocation

private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

class HKHomeController: UIViewController {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    
    let APP_ID = "2bdfd84d108371780d9d4ca0448994d2"
    
    let weatherDataModel = WeatherDataModel()
    // 定位管理
    var locationManager = CLLocationManager()
    
        var myBookData = [StoryModel]()
    var local = "杭州"
    // 左边返回按钮
     private lazy var leftBarButton: UIButton = {
         let button = UIButton.init(type: .custom)
         button.frame = CGRect(x:10, y:0, width:50, height: 30)
//         button.setImage(UIImage(named: "home_detail_location"), for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        button.setTitleColor(UIColor.init(r: 56, g: 56, b: 56), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//         button.addTarget(self, action: #selector(back), for: .touchUpInside)
         return button
     }()
    
    /// 右边功能按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
       // button.frame = CGRect(x:10, y:100, width:40, height: 40)
        button.addTarget(self, action: #selector(tip), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "home_icon_tip"), for: .normal)
        //button.backgroundColor = UIColor.red
        return button
    }()
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = false
        layout.titleViewBgColor = backColor
        layout.titleSelectColor = UIColor.init(r: 0, g: 0, b: 0)
        layout.bottomLineColor = UIColor.init(r: 64, g: 223, b: 238)
        layout.sliderHeight = 48
        layout.lrMargin = 20
        layout.showsHorizontalScrollIndicator = false
        layout.isHiddenPageBottomLine = true
        layout.isShowBounces = true
        layout.pageBottomLineHeight = 0
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        print(statusBarH)
        let Y: CGFloat = statusBarH + 88
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y ) : view.bounds.height - Y
        return CGRect(x: 0, y: statusBarH, width: view.bounds.width, height: H)
    }
    private  var viewControllers = [UIViewController]()
    private  var titles = ["推荐故事","同城附近","关注达人","金秋之行","红色之旅"]
    
    lazy var headerView:HKHomeHeaderView = {
        let headerView = HKHomeHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 480))
        let model = City(title: "上海", img: "image1")
        //let model2 = City(title: "株洲", img: "img2")
        let model3 = City(title: "长沙", img: "img3")
        let model4 = City(title: "杭州", img: "img4")
        let model5 = City(title: "北京", img: "image5")
        let model6 = City(title: "深圳", img: "image7")
        let model7 = City(title: "香港", img: "image6")
        
        headerView.cityData.append(model)
       // headerView.cityData.append(model2)
        headerView.cityData.append(model5)
        headerView.cityData.append(model6)
        headerView.cityData.append(model7)
        headerView.cityData.append(model3)
        headerView.cityData.append(model4)


        headerView.rightBarButton.addTarget(self, action: #selector(tip), for: .touchUpInside)
        headerView.delegate = self
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
        configUI()
        advancedManagerConfig()
        view.backgroundColor = backColor
                configLocation()
        configHKStoryData()
    }
    // 定位
    func configLocation(){
        locationManager.delegate = self
        // 定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    @objc func tip(){

        
        let tipsVC = TipsViewController()
        navigationController?.pushViewController(tipsVC, animated: true)
    }
      func configHKStoryData(){
          self.myBookData.removeAll()
          
          UserDefaults.standard.removeObject(forKey: "bookname")
          UserDefaults.standard.removeObject(forKey: "bookid")
          UserDefaults.standard.removeObject(forKey: "booknum")
    
          Alamofire.request(getMyBookAPI(userId: getUserId()!)).responseJSON { (response) in
              guard response.result.isSuccess else {
                  ProgressHUD.showError("网络请求错误"); return
              }
              if let value = response.result.value {
                  let json = JSON(value)
                  if let obj = JSONDeserializer<HKStory>.deserializeFrom(json: json.debugDescription){
                      for data in obj.data! {
                          self.myBookData.append(data)
                      }
                      var bookname = [String]()
                      var bookid = [Int]()
                      var booknum = [Int]()
                      for data in self.myBookData {
                          bookname.append(data.bookName)
                          bookid.append(data.id)
                          booknum.append(data.story!.count)
                      }
                      print("bookname",bookname)
                      saveBookId(bookname: bookid)
                      saveBookName(bookname: bookname)
                      saveBookNum(bookname: booknum)
                  }
              }
          }
      }
    
}

extension HKHomeController {
    func configUI(){
        self.view.backgroundColor = .white
        let vc = HomeController()
        let cityVC = CityController(word: "杭州")
        let concernVC = ConcernController()
        let gqVC = GuoQingViewController(word:"2019-10")
        let hsVC = HongseViewController(words: ["北京","湘潭"])
        viewControllers = [vc,cityVC,concernVC,gqVC,hsVC]

        let advancedManager = LTAdvancedManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.headerView
            return headerView
        })
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self
        
        //设置悬停位置
        advancedManager.hoverY = 44
        
        /* 点击切换滚动过程动画 */
        advancedManager.isClickScrollAnimation = true
        
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        view.addSubview(advancedManager)
    }
    
    func configNav(){
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = false
//            self.navigation.item.largeTitleDisplayMode = .automatic
        }
        //navigation.bar.automaticallyAdjustsPosition = false
        //self.navigation.item.title = "发现"
        self.navigation.bar.alpha = 0
        self.navigation.bar.isShadowHidden = true
//        if TKHeight >= 812 {
//                self.navigation.bar.frame.origin.y = 44
//        }else {
//                self.navigation.bar.frame.origin.y = 20
//        }
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
    }
}
extension HKHomeController: LTAdvancedScrollViewDelegate {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
//        advancedManager.advancedDidSelectIndexHandle = {
//            print("选中了 -> \($0)")
//        }

        
        
    }
    
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        if offsetY >= 50 {
            self.navigation.bar.alpha = 1
            self.navigation.item.title = "发现"
            self.rightBarButton.setImage(UIImage(named: "home_icon_tip"), for: .normal)
            if offsetY >= 88 {
                self.leftBarButton.setImage(UIImage(named: "home_detail_location"), for: .normal)
                self.leftBarButton.setTitle(self.local, for: .normal)
            }else {
                self.leftBarButton.setImage(UIImage(), for: .normal)
                self.leftBarButton.setTitle("", for: .normal)
            }
        }
        else {
            self.navigation.bar.alpha = 0
            self.navigation.item.title = ""
            self.rightBarButton.setImage(UIImage(), for: .normal)
        }
    }
}
extension HKHomeController: HomeHeaderDelegate {
    func cityClicks(with data: String) {
        let vc = SearchContentViewController(word: data)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchClicks() {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

}

// MARK: - 定位代理
extension HKHomeController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            
            
            print("经度 = \(location.coordinate.longitude)，纬度 = \(location.coordinate.latitude)")
                let currLocation = locations.last!
            
            lonLatToCity(location: currLocation)
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
          let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID,"lang":"zh_cn"]
           getWeatherData(url: WEATHER_URL, parameters: params)
            
            //定位完成,关闭持续定位
            locationManager.stopUpdatingLocation()
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("定位失败")
        //cityLabel.text = "定位失败"
    }
    
    func lonLatToCity(location:CLLocation) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            
            if(error == nil)
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //国家
                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                //国家编码
                let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
                //街道位置
                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                //具体位置
                let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
//                //省
//                let State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //区
                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                
                print("定位:",CountryCode,country,city,SubLocality,FormattedAddressLines,Name)
                let location = (city as NSString).substring(to: 2)
                self.headerView.location.text = location
                self.local = location
                //如果需要去掉“市”和“省”字眼
                
                //                State = State.stringByReplacingOccurrencesOfString("省", withString: "")
                //                let citynameStr = city.stringByReplacingOccurrencesOfString("市", withString: "")
            }
            else
            {
                print(error)
            }
        }
    }
}

// 天气请求
extension HKHomeController {
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            print(parameters)
            if response.result.isSuccess {
                print("成功获取气象数据")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }else {
                print("错误 \(String(describing: response.result.error))")
                print("天气数据获取失败")
                //self.cityLabel.text = "连接问题"
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        print(json)
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.condition = json["weather"]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherDescribe = json["weather"][0]["description"].stringValue
                        updateUIWithWeatherData()
        }else {
            print("信息不够用")
        }
    }
    func updateUIWithWeatherData() {
        self.headerView.weather.text =             weatherDataModel.weatherDescribe + " \(weatherDataModel.temperature)" + "°C"
        self.headerView.weatherIcon.image = UIImage(named: weatherDataModel.updateWeatherIcon(condition: 800))
    }
}
