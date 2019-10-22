//
//  NoteController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/25.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import ProgressHUD
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SwiftDate
import Lightbox

class NoteController: UIViewController,NVActivityIndicatorViewable{
//,DataToEasyDelegate {
//    let keyMap = ["building":["塔","高楼","小洋房","别墅","学校"],
//                  "food":["美食","食品","小吃","面","汤包"],
//                  "landscape":["美景","山","水","湖","湖泊","江","白云"],
//                  "animal":["猫","狗","猴子"],
//                  "night_scene":["夜","深夜","傍晚","黄昏"],
//                  "face":["人"]
//                ]
//
//    func recognize(current: Int, max: Int) {
//            DispatchQueue.main.async {
//                       self.tipLabel.text = "第一次配图需要给系统照片分类，正在分类图片\(current)/\(max)，如果数字卡死，请重启App"
//
//        }
//    }
//    var photoDataManager: PhotoDataManager
//
//
//    init(_ photoDataManager: PhotoDataManager) {
//    self.photoDataManager = photoDataManager
//    super.init(nibName: nil, bundle: nil)
//    self.photoDataManager.dataToEasyDelegate = self
//    }
//
//    required  init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//    }
    /// 照片选择
    var imgPricker:UIImagePickerController!
    var imgs: String = ""
    var time: String = ""
    var location: String = ""
    var images = [String]()
    
    var nowdate: Date?
    var startDate: Date?
    var endDate: Date?
    
        var requestEndFlag = false
    var upPhotoNum = 0
    var selectPhotoNum = 0
    
    // 数据
    var datas = NotesModel()
    
    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:20, y:44, width:40, height: 40)
        button.setImage(UIImage(named: "home_icon_back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    /// 右边完成按钮
    private lazy var rightBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:-10, y:0, width:30, height: 30)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    lazy var writeTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = UIColor.init(r: 204, g: 204, b: 204  )
        tv.text = "以段落的形式分享您旅途中印象深刻的故事、有趣的体验吧~"
        tv.delegate = self
        return tv
    }()
    
    lazy var locationBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_locations"), for: .normal)
        btn.setTitle("添加地点", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.init(r: 222, g: 237, b: 254)
        btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        return btn
    }()
    
    lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_time"), for: .normal)
        btn.setTitle("添加时间", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.init(r: 222, g: 237, b: 254)
        btn.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(addTime), for: .touchUpInside)
        return btn
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "智能配图功能正在测试，暂未上线。预计将在10月24日上线。"
        label.numberOfLines = 0
        return label
    }()
    

    private lazy var loginView : LocationView = {
        let loginView = LocationView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight))
            var bookData = [BookModel]()
            var bookmodel = BookModel()
            let albums = DataSingle.shared.locationAlbums.map { $0.value }
            for album in albums {
            print(album.name)
                bookmodel.name = album.name
                bookmodel.num = album.photos.count
                bookData.append(bookmodel)
            }
                loginView.data = bookData
        loginView.delegate = self
        return loginView
    }()
//    lazy var photoView:UIView = {
//       let vi = UIView()
//        return vi
//    }()
    lazy var tagBtn:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("# 添加标签", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.init(r: 64, g: 102, b: 214), for: .normal)
        btn.addTarget(self, action: #selector(nextNote), for: .touchUpInside)
        return btn
    }()
    var tag = [String]()
    lazy var tag1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.textColor = UIColor.init(r: 146, g: 146, b: 146)
        label.backgroundColor = UIColor.init(r: 238, g: 243, b: 249)
        label.layer.cornerRadius = 14
        label.textAlignment = .center
        return label
    }()
    lazy var tag2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.textColor = UIColor.init(r: 146, g: 146, b: 146)
        label.backgroundColor = UIColor.init(r: 238, g: 243, b: 249)
                label.layer.cornerRadius = 14
        label.textAlignment = .center
        return label
    }()
    lazy var tag3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.backgroundColor = UIColor.init(r: 238, g: 243, b: 249)
        label.textColor = UIColor.init(r: 146, g: 146, b: 146)
        label.layer.cornerRadius = 14
        label.textAlignment = .center
        return label
    }()
    lazy var addPhotoBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("添加图片", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        
        //btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return btn
    }()
    lazy var photoCell:PhotoCell = {
        let photoCell = PhotoCell()
        return photoCell
    }()
    
    var dismissKetboardTap = UITapGestureRecognizer()
    
    let c1 = getContent()
    let c2 = getLocation()
    let c3 = getTime()
    let c4 = getPic()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

}


// MRAK - setUI

extension NoteController {
    func configNav(){
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.backgroundColor = .white
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        view.backgroundColor = backColor
        self.navigation.bar.isShadowHidden = true
        self.navigation.item.title = "添加故事段落"
    }
    
    func configUI(){
        dismissKetboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKetboardTap)
        
        view.backgroundColor = .white
        view.addSubview(writeTextView)
        view.addSubview(locationBtn)
        view.addSubview(timeBtn)
        view.addSubview(tipLabel)
        
        view.addSubview(tagBtn)
        view.addSubview(tag1)
        view.addSubview(tag2)
        view.addSubview(tag3)
        //view.addSubview(photoView)
        self.tag1.isHidden = true
        self.tag2.isHidden = true
        self.tag3.isHidden = true
        view.addSubview(addPhotoBtn)
        view.addSubview(photoCell)
        
        writeTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigation.bar.snp.bottom)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(200)
        }
        locationBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(locationBtn.snp.bottom).offset(5)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(TKWidth-40)
        }
        timeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(160)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        tagBtn.snp.makeConstraints { (make) in
            make.top.equalTo(timeBtn.snp.bottom).offset(25)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        tag1.snp.makeConstraints { (make) in
            make.top.equalTo(tagBtn.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        tag2.snp.makeConstraints { (make) in
            make.top.equalTo(tagBtn.snp.bottom).offset(10)
            make.left.equalTo(view).offset(110)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        tag3.snp.makeConstraints { (make) in
            make.top.equalTo(tagBtn.snp.bottom).offset(10)
            make.left.equalTo(view).offset(200)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
//        photoView.snp.makeConstraints { (make) in
//            make.height.equalTo(200)
//        }
        
        addPhotoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-40)
            make.height.equalTo(40)
        }
        photoCell.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(addPhotoBtn.snp.top)
            make.height.equalTo(200)
        }


        DispatchQueue.main.async {
            self.addPhotoBtn.corner(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 10)
        }
        
    }
    
    @objc func photoCellClick() {
        var imgs = [LightboxImage]()
        for pic in images {
            
            let img = LightboxImage(imageURL: URL(string: pic)!, text: "")
            imgs.append(img)
        }

        let controller = LightboxController(images: imgs)
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}

// MRAK - @objc function

extension NoteController {
    
    
    @objc func back(){
//        UserDefaults.standard.removeObject(forKey: "content")
//        UserDefaults.standard.removeObject(forKey: "time")
//        UserDefaults.standard.removeObject(forKey: "pic")
//        UserDefaults.standard.removeObject(forKey: "location")
         saveFlag(flag: "001")
         self.navigationController?.popToRootViewController(animated: true)
        
    }
    @objc func addLocation(){
        
        UIApplication.shared.keyWindow?.addSubview(self.loginView)

        self.loginView.showAddView()
        
//        let alert = UIAlertController.init(title: "消息", message: "请添加地点信息", preferredStyle: .alert)
//
//        let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
//            self.location =  (alert.textFields?.first?.text!)!
//                    self.locationBtn.setTitle( (alert.textFields?.first?.text!)!, for: .normal)
//            ProgressHUD.showSuccess("地点添加成功")
//        }
//        let noAction = UIAlertAction.init(title: "取消", style: .destructive) { (no) in
//            print("地点信息取消",no.style)
//        }
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        alert.addTextField { (text) in
//            print(text.text,11)
//
//        }
//
//        self.present(alert, animated: true, completion: nil)


    }
    @objc func addTime(){
        let picker = QDatePicker { (date: Date) in
            self.timeBtn.setTitle("\(date.formatterDate(formatter: "yyyy-MM-dd"))", for: .normal)
            self.time = date.formatterDate(formatter: "yyyy-MM-dd")
            self.nowdate = date
            self.startDate = date - 10.days
            self.endDate = date + 10.days
        }
        picker.datePickerStyle = .YMD
        picker.themeColor = UIColor.init(r: 55, g: 194, b: 207)
        picker.pickerStyle = .datePicker
        picker.animationStyle = .styleDefault
        picker.show()
        
    }
    @objc func save(){
        let tvtext = writeTextView.text!


        
        if tvtext == "以段落的形式分享您旅途中印象深刻的故事、有趣的体验吧~" || tvtext == ""{
            ProgressHUD.showError("请写入内容")
        }else{
            if location == ""{
                    ProgressHUD.showError("请添加地点")
            }else {
                if time == ""{
                    ProgressHUD.showError("请添加时间")
                }else {
                    if images.count == 0 {
                        ProgressHUD.showError("请至少添加一张图片")
                    }else {
                        var contents = [String]()
                        let locaCon = getContent()
                        if  locaCon == nil {
                            contents.append(writeTextView.text!)
                        }else {
                            contents = locaCon!
                            contents.append(writeTextView.text!)
                        }
                        saveContent(content: contents)
                        
                        var locations = [String]()
                        let locLoc = getLocation()
                        if locLoc == nil {
                            locations.append(self.location)
                        }else {
                            locations = locLoc!
                            locations.append(self.location)
                        }
                        saveLocation(location: locations)
                        
                        var times = [String]()
                        let locTime = getTime()
                        if locTime == nil {
                            times.append(self.time)
                        }else {
                            times = locTime!
                            times.append(self.time)
                        }
                        saveTime(content: times)
                        
                        var imgs = [String]()
                        let locImg = getPic()
                        let imagess = self.images.joined(separator: ",")
                        if locImg == nil {
                            imgs.append(imagess)
                        }else {
                            imgs = locImg!
                            imgs.append(imagess)
                        }
                        
                        savePic(content: imgs)
                        
                        
                        var tags = [[String]]()
                        let loctag = getTags()
                        let tagss = self.tag
                        if loctag == nil {
                            tags.append(tagss)
                        }else {
                            tags = loctag!
                            tags.append(tagss)
                        }
                        saveTags(tags:tags )
                        
                        let c1 = getContent()
                        let c2 = getLocation()
                        let c3 = getTime()
                        let c4 = getPic()
                        let c5 = getTags()

                            
                             var paras = [NoteParas]()
                             var para = NoteParas()
                             for index in 0 ..< c1!.count {
                                 para.content = c1![index]
                                 para.date = c3![index]
                                 para.pics = c4![index]
                                 para.place = c2![index]
                                para.tags = c5![index]
                                 paras.append(para)
                             }
                             datas.noteParas = paras
                             let noteVC = NotesController(data: datas)
                             self.navigationController?.pushViewController(noteVC, animated: true)
                         
                    }
                }
            }
        }
        
        
 
        
    
    }
    
    @objc func dismissKeyboard(){
        print("键盘成功关闭")
        self.view.endEditing(false)
    }
    
    @objc func nextNote(){
        
        if self.tag.count == 3{
            ProgressHUD.showError("最多添加三个标签")
        }else {
        
            let alert = UIAlertController.init(title: "消息", message: "请添加标签信息", preferredStyle: .alert)
        
            let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
                    self.tag.append((alert.textFields?.first?.text!)!)

                    self.updateTag()
                    ProgressHUD.showSuccess("标签添加成功")
            }
            let noAction = UIAlertAction.init(title: "取消", style: .default) { (no) in
                print("地点信息取消",no.style)
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            alert.addTextField { (text) in
                print(text.text,11)
    
            }
        
            self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    func updateTag(){
        if self.tag.count == 1{
            self.tag1.text = tag[0]
            self.tag1.isHidden = false
        }else if tag.count == 2{
            self.tag1.text = tag[0]
            self.tag2.text = tag[1]
                        self.tag1.isHidden = false
                        self.tag2.isHidden = false
        }else if tag.count == 3{
            self.tag1.text = tag[0]
            self.tag2.text = tag[1]
            self.tag3.text = tag[2]
                        self.tag1.isHidden = false
                        self.tag2.isHidden = false
                        self.tag3.isHidden = false
        }
    }
    @objc func addPhoto(){
        
        self.upPhotoNum = 0
        self.selectPhotoNum = 0
        self.images  = [String]()

        
//      //  ProgressHUD.show("配图中")
//        let strs = "西湖的水很美，杭州的美食也不错，人也有点多噢，今日打卡西湖。"
//        let tvtext = writeTextView.text!
//
//        if tvtext == "以段落的形式分享您旅途中印象深刻的故事、有趣的体验吧~" || tvtext == ""{
//            ProgressHUD.showError("请写入内容")
//        }else{
//            if location == ""{
//                    ProgressHUD.showError("添加地点可以提高匹配精度哦")
//            }else {
//                if time == ""{
//                    ProgressHUD.showError("添加时间可以提高匹配精度哦")
//                }else {
//                        let size = CGSize(width: 30, height: 30)
//                    self.startAnimating(size, message: "本地图片加载中", type: .ballClipRotate, fadeInAnimation: nil)
//
//                    var total = ["building":0,"food":0,"landscape":0,"animal":0,"night_scene":0,"face":0]
//
//                     for str in strs {
//                        for (key,value) in self.keyMap {
//                            if (self.keyMap[key]?.contains(String(str)))! {
//                                total[key]! += 1
//                            }else {
//
//                            }
//                        }
//                     }
//                    let lasted = total.sorted {(s1,s2) -> Bool in
//                        return s1.1 > s2.1
//                    }
//                    var wordArray = [String]()
//                    print(total,lasted[0].value)
//                    for lst in lasted {
//                        if lst.value == 0 {
//                            break;
//                        }
//                        wordArray.append(lst.key)
//                    }
//
//                    print(wordArray)
//                    var datas = [Photo]()
//                    for word in wordArray {
//                        var classify = [String]()
//                        classify.append(word)
//                        var locationChoice = [String]()
//                        locationChoice.append(self.location)
//                        let newAlbum = NewAlbum.init(name: "智能配图", classifyChoice: classify, locationChoice: locationChoice, beginTime: self.startDate, endTime: self.endDate)
//                        if let photo =  self.photoDataManager.addCustomAlbum(condition: newAlbum) {
//                            // 这里处理获取的图片
//                            datas.append(photo[0])
//                        }
//
//                    }
//                    var imgsData = [UIImage]()
//                    // 配图失败处理
//                    if datas.count == 0 {
//
//                            self.stopAnimating(nil)
//                         ProgressHUD.showError("配图失败")
//                    }else {
//                        for data in datas {
////                            imgsData.append(SKPHAssetToImageTool.PHAssetToImage(asset: data.asset))
//                            self.selectPhotoNum = datas.count
//                            let img = SKPHAssetToImageTool.PHAssetToImage(asset: data.asset)
//                            let up = self.uploadPic(image: img)
//                        }
//
//
//                        //self.photoCell.updateUILocal(imgsData.count, with: imgsData)
//                    }
//
//                }
//            }
//
//        }
        
        
        
             //   开始选择照片，最多允许选择4张
                _ = self.presentHGImagePicker(maxSelected:3) { (assets) in
                    //结果处理
                    self.selectPhotoNum = assets.count
                        let size = CGSize(width: 30, height: 30)
                    self.startAnimating(size, message: "本地图片加载中", type: .ballClipRotate, fadeInAnimation: nil)

                    var seleimgs = [String]()
                    for asset in assets {
                        let img = SKPHAssetToImageTool.PHAssetToImage(asset: asset)
                        seleimgs.append(self.uploadPic(image: img))
                    }
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.photoCellClick))
                    self.photoCell.addGestureRecognizer(tap)
                    
        }

                    
//                    self.photoCell.removeFromSuperview()

//                    print("共选择了\(assets.count)张图片，分别如下：")
//                    var seleImgs = [UIImage]()
//                    var imgsData = [Data]()
//                    var datas = [[Data]]()

//                    self.view.addSubview(self.photoCell)
//                    self.photoCell.snp.makeConstraints { (make) in
//                        make.left.equalTo(self.view).offset(20)
//                        make.right.equalTo(self.view).offset(-20)
//                        make.bottom.equalTo(self.addPhotoBtn.snp.top)
//                        make.height.equalTo(200)
//                    }
//
//                    datas.append(imgsData)
//                    saveImgs(datas: datas)
//                    let getdatas = getImgs()
//                    for gdatas in getdatas {
//                        for data in gdatas {
//                            let myImage = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIImage
//                            print("imgdata",myImage)
//                        }
//                    }

        //            self.photoCell.snp.makeConstraints { (make) in
        //                make.left.equalTo(view).offset(20)
        //                make.right.equalTo(view).offset(-20)
        //                make.bottom.equalTo(addPhotoBtn.snp.top)
        //                make.height.equalTo(200)
        //            }

               // }
        



//        self.imgPricker = UIImagePickerController()
//        self.imgPricker.delegate = self
//        self.imgPricker.allowsEditing = true
//        self.imgPricker.sourceType = .photoLibrary
//
//        self.imgPricker.navigationBar.barTintColor = UIColor.gray
//        self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//
//        self.imgPricker.navigationBar.tintColor = UIColor.white
//
//        self.present(self.imgPricker, animated: true, completion: nil)
    }
}

// MRAK - TextViewDelegate

extension NoteController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
        if (content.text == "以段落的形式分享您旅途中印象深刻的故事、有趣的体验吧~") {
            content.text = ""
            content.textColor = UIColor.black
        }else {
            content.textColor = UIColor.gray
        }
        return true
    }
}
// MARK - 照片调用
extension NoteController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("图片选取成功")
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //转成jpg格式图片
        let jpegData = UIImage.jpegData(img)(compressionQuality: 1)
        
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        //let file = Bundle.main.url(forResource: , withExtension: <#T##String?#>)
        
        
        let imageData1 = try! Data(contentsOf: imageURL as! URL)
        
        let imgUrl = (imageURL as! URL).path
        
        let image = UIImage(contentsOfFile: imgUrl)
        
        let imageData = UIImage.jpegData(image!)(compressionQuality: 1)

        
        
        
        self.imgs = imgUrl
        if images.count < 3 {
            self.images.append(imgUrl)
        }else {
            ProgressHUD.showError("最多只能选择三张图片")
        }
        self.photoCell.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(addPhotoBtn.snp.top)
            make.height.equalTo(200)
        }
        self.photoCell.isLocalImage = true
        self.photoCell.imgDatas = images
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NoteController: LocationDelegate {
    func passBookData(with name: String, id: Int) {
        self.location = name
        self.locationBtn.setTitle( name, for: .normal)
    }
    
    func uploadPic(image:UIImage) -> String{
//        let image = UIImage(contentsOfFile: imageURL)
        let imageData = UIImage.jpegData(image)(compressionQuality: 0.5)
        var imgUrl = ""
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let now = Date()
            let timeForMatter = DateFormatter()
            timeForMatter.dateFormat = "yyyyMMddHHmmss"
            let id = timeForMatter.string(from: now)
            
            multipartFormData.append(imageData!, withName: "file", fileName: "\(id).jpg",mimeType: "image/jpeg")
            print("图片准备上传")

        }, to: getImageAPI()) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseString{ response in
                    if let data = response.data {
                        let json = JSON(data)
                        imgUrl = json["data"].stringValue
                        //self.requestEndFlag = true
                        print(json)
                        self.images.append(imgUrl)
                        
                        self.upPhotoNum += 1
                        if self.upPhotoNum == self.selectPhotoNum {
                            print(self.images)
                            self.photoCell.imgDatas = self.images
                            self.stopAnimating(nil)
                            ProgressHUD.showSuccess("完成")
                        }
                    }
                    //获取上传进度
                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("图片上传进度: \(progress.fractionCompleted)")
                    }
                }
            case .failure(_):
                print("上传失败")
            }

        }
       // waitingRequestEnd()
       // self.requestEndFlag = false
        print("图片上传完成")
        return imgUrl
    }
    
    /// 异步数据请求同步化
    func waitingRequestEnd() {
        if Thread.current == Thread.main {
            while !requestEndFlag {
                RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.3))
            }
        } else {
            autoreleasepool {
                while requestEndFlag {
                    Thread.sleep(forTimeInterval: 0.3)
                }
            }
        }
    }
    
    
}
////选择成功后代理
//func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
//    if flag == "视频" {
//
//        //获取选取的视频路径
//        let videoURL = info[UIImagePickerControllerMediaURL] as! URL
//        let pathString = videoURL.path
//        print("视频地址：\(pathString)")
//        //图片控制器退出
//        self.dismiss(animated: true, completion: nil)
//        let outpath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
//        //视频转码
//        self.transformMoive(inputPath: pathString, outputPath: outpath)
//    }else{
//        //flag = "图片"
//
//        //获取选取后的图片
//        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        //转成jpg格式图片
//        guard let jpegData = UIImageJPEGRepresentation(pickedImage, 0.5) else {
//            return
//        }
//        //上传
//        self.uploadImage(imageData: jpegData)
//        //图片控制器退出
//        self.dismiss(animated: true, completion:nil)
//    }
//}
//
////上传图片到服务器
//func uploadImage(imageData : Data){
//    Alamofire.upload(
//        multipartFormData: { multipartFormData in
//            //采用post表单上传
//            // 参数解释：
//            //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的，要上传其他格式可以自行百度查一下
//            multipartFormData.append(imageData, withName: "file", fileName: "123456.jpg", mimeType: "image/jpeg")
//            //如果需要上传多个文件,就多添加几个
//            //multipartFormData.append(imageData, withName: "file", fileName: "123456.jpg", mimeType: "image/jpeg")
//            //......
//
//    },to: uploadURL,encodingCompletion: { encodingResult in
//        switch encodingResult {
//        case .success(let upload, _, _):
//            //连接服务器成功后，对json的处理
//            upload.responseJSON { response in
//                //解包
//                guard let result = response.result.value else { return }
//                print("json:\(result)")
//            }
//
//        case .failure(let encodingError):
//            //打印连接失败原因
//            print(encodingError)
//        }
//    })
//}
        

