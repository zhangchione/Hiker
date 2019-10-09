//
//  NoteViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/20.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import ProgressHUD


class NoteViewController: UIViewController {
    var imgPricker:UIImagePickerController!
    var noteData = Notes()
    
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
        button.setTitle("放弃", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(headclick), for: .touchUpInside)
        return button
    }()
    
    lazy var writeTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = UIColor.init(r: 204, g: 204, b: 204  )
        tv.text = "以段落的形式分享您旅途中印象深刻的故事、有趣的体验，行迹将帮助您从系统相册中匹配图片发表游记。"
        tv.delegate = self
        return tv
    }()
    
    lazy var locationBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_location"), for: .normal)
        btn.setTitle("添加地点", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(addlocation), for: .touchUpInside)
        return btn
    }()
    
    lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_location"), for: .normal)
        btn.setTitle("添加时间", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(addTime), for: .touchUpInside)
        return btn
    }()
    
    lazy var nextBtn:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("下一段", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        return btn
    }()
    lazy var headBtn:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("完成", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        return btn
    }()
    
    lazy var addPhotoBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_location"), for: .normal)
        btn.setTitle("添加照片", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.black
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 0.8
        btn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_location"), for: .normal)
        btn.setTitle("游记完成", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.white
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 0.8
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNav()
        configUI()
    }
    func configUI(){
        view.backgroundColor = .white
        view.addSubview(writeTextView)
        view.addSubview(locationBtn)
        view.addSubview(timeBtn)
        view.addSubview(addPhotoBtn)
        view.addSubview(nextBtn)
        view.addSubview(headBtn)
        //view.addSubview(saveBtn)
        
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
        timeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(160)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        addPhotoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(timeBtn.snp.bottom).offset(AdaptH(10))
            make.height.equalTo(AdaptH(40))
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotoBtn.snp.bottom).offset(25)
            make.right.equalTo(view).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        headBtn.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotoBtn.snp.bottom).offset(25)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
    }
    

    func configNav(){
        self.navigation.item.title = "写故事"
        self.navigation.bar.isShadowHidden = true
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
    }
    
    @objc func save(){
        let c1 = getContent()
        let c2 = getLocation()
        let c3 = getTime()
        let c4 = getPic()
        print(c1)
        print(c2)
        print(c3)
        print(c4)
        
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    var location = ""
    var time = ""
    var img = ""
    
    @objc func nextClick(){
        noteData.content = writeTextView.text
        
        var contents = [String]()
        let locaCon = getContent()
        if  locaCon == nil {
            contents.append(writeTextView.text!)
            print(writeTextView.text!)
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
        
//        var imgs = [String]()
//        let locImg = getPic()
//        if locImg == nil {
//            imgs.append(self.img)
//        }else {
//            imgs = locImg!
//            imgs.append(self.img)
//        }
//        savePic(content: imgs)
//        
        let noteVC = NoteViewController()
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
    @objc func headclick(){
        UserDefaults.standard.removeObject(forKey: "content")
        UserDefaults.standard.removeObject(forKey: "time")
        UserDefaults.standard.removeObject(forKey: "pic")
        UserDefaults.standard.removeObject(forKey: "location")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func addPhoto(){
        self.imgPricker = UIImagePickerController()
        self.imgPricker.delegate = self
        self.imgPricker.allowsEditing = true
        self.imgPricker.sourceType = .photoLibrary
        
        self.imgPricker.navigationBar.barTintColor = UIColor.gray
        self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        self.imgPricker.navigationBar.tintColor = UIColor.white
        
        self.present(self.imgPricker, animated: true, completion: nil)
        
    }
    
    @objc func addTime(){
        let now = Date()
        let timeForMatter = DateFormatter()
        
        
        timeForMatter.dateFormat = "yyyy-MM-dd"
        let id = timeForMatter.string(from: now)
        
        self.time = id
        self.timeBtn.setTitle(id, for: .normal)
        ProgressHUD.showSuccess("时间添加成功")
    }
    
    @objc func addlocation(){
        self.location = "上海"
        self.locationBtn.setTitle("上海", for: .normal)
                ProgressHUD.showSuccess("地点添加成功")
//        let alert = UIAlertController.init(title: "提示", message: "请您添加游记地点", preferredStyle: .alert)
//
//        let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
//            let location = (alert.textFields?.first!.text)!
//            self.noteData.location = location
//            self.locationBtn.setTitle(location, for: .normal)
//            self.location = location
//            ProgressHUD.showSuccess("地点添加成功")
//        }
//        let noAction = UIAlertAction.init(title: "取消", style: .cancel) { (no) in
//        }
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        alert.addTextField { (text) in
//        }
//        self.present(alert, animated: true, completion: nil)
    }
    
    var topColor = UIColor.black
}
extension NoteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
        if (content.text == "以段落的形式分享您旅途中印象深刻的故事、有趣的体验，行迹将帮助您从系统相册中匹配图片发表游记。") {
            content.text = ""
        }
        if self.topColor == .black {
            content.textColor = UIColor.green
        }else {
            content.textColor = UIColor.black
        }
        return true
    }
}
extension NoteViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("图片选取成功")
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        let imageData1 = try! Data(contentsOf: imageURL as! URL)

        let imgUrl = (imageURL as! URL).path
        self.img = imgUrl
        self.noteData.pic = imgUrl
        
       // self.noteData.pic.append(imgUrl)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

