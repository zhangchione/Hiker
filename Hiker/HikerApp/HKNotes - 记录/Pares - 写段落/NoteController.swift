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


class NoteController: UIViewController {
    /// 照片选择
    var imgPricker:UIImagePickerController!
    var imgs: String = ""
    var time: String = ""
    var location: String = ""
    var images = [String]()
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
        btn.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
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
        btn.addTarget(self, action: #selector(nextNote), for: .touchUpInside)
        return btn
    }()
    
//    lazy var photoView:UIView = {
//       let vi = UIView()
//        return vi
//    }()
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
        self.navigation.item.title = "第一段故事"
    }
    
    func configUI(){
        dismissKetboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKetboardTap)
        
        view.backgroundColor = .white
        view.addSubview(writeTextView)
        view.addSubview(locationBtn)
        view.addSubview(timeBtn)
        view.addSubview(nextBtn)
        //view.addSubview(photoView)
        
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
        timeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(view).offset(160)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
//        nextBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(timeBtn.snp.bottom).offset(25)
//            make.right.equalTo(view).offset(-20)
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//        }
        
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
}

// MRAK - @objc function

extension NoteController {
    
    
    @objc func back(){
        UserDefaults.standard.removeObject(forKey: "content")
        UserDefaults.standard.removeObject(forKey: "time")
        UserDefaults.standard.removeObject(forKey: "pic")
        UserDefaults.standard.removeObject(forKey: "location")
        
        let c1 = getContent()
        let c2 = getLocation()
        let c3 = getTime()
        let c4 = getPic()
        print(c1)
        print(c2)
        print(c3)
        print(c4)
        
    }
    @objc func addLocation(){
        
        let alert = UIAlertController.init(title: "消息", message: "请添加地点信息", preferredStyle: .alert)
        
        let yesAction = UIAlertAction.init(title: "确定", style: .default) { (yes) in
            self.location =  (alert.textFields?.first?.text!)!
                    self.locationBtn.setTitle( (alert.textFields?.first?.text!)!, for: .normal)
            ProgressHUD.showSuccess("地点添加成功")
        }
        let noAction = UIAlertAction.init(title: "取消", style: .destructive) { (no) in
            print("地点信息取消",no.style)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        alert.addTextField { (text) in
            print(text.text,11)
            
        }

        self.present(alert, animated: true, completion: nil)


    }
    @objc func addTime(){
        let picker = QDatePicker { (date: Date) in
            self.timeBtn.setTitle("\(date.formatterDate(formatter: "yyyy-MM-dd"))", for: .normal)
            self.time = date.formatterDate(formatter: "yyyy-MM-dd")
        }
        picker.datePickerStyle = .YMD
        picker.themeColor = UIColor.init(r: 55, g: 194, b: 207)
        picker.pickerStyle = .datePicker
        picker.animationStyle = .styleDefault
        picker.show()
        
    }
    @objc func save(){
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
        
        let c1 = getContent()
        let c2 = getLocation()
        let c3 = getTime()
        let c4 = getPic()
        
        if c1 == nil {
            ProgressHUD.showError("暂无段落")
        }else {
            var paras = [NoteParas]()
            var para = NoteParas()
            for index in 0 ..< c1!.count {
                para.content = c1![index]
                para.date = c3![index]
                para.pics = c4![index]
                para.place = c2![index]
                paras.append(para)
                
            }
            datas.noteParas = paras
            let noteVC = NotesController(data: datas)
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
        
    
    }
    
    @objc func dismissKeyboard(){
        print("键盘成功关闭")
        self.view.endEditing(false)
    }
    
    @objc func nextNote(){
        
    }
    @objc func addPhoto(){
        print("本地相册打开")
        self.imgPricker = UIImagePickerController()
        self.imgPricker.delegate = self
        self.imgPricker.allowsEditing = true
        self.imgPricker.sourceType = .photoLibrary
        
        self.imgPricker.navigationBar.barTintColor = UIColor.gray
        self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        self.imgPricker.navigationBar.tintColor = UIColor.white
        
        self.present(self.imgPricker, animated: true, completion: nil)
    }
}

// MRAK - TextViewDelegate

extension NoteController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
        if (content.text == "以段落的形式分享您旅途中印象深刻的故事、有趣的体验，行迹将帮助您从系统相册中匹配图片发表游记。") {
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
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //转成jpg格式图片
        let jpegData = UIImage.jpegData(img)(compressionQuality: 1)
        
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        //let file = Bundle.main.url(forResource: , withExtension: <#T##String?#>)
        
        
        let imageData1 = try! Data(contentsOf: imageURL as! URL)
        
        let imgUrl = (imageURL as! URL).path
        
        let image = UIImage(contentsOfFile: imgUrl)
        
        let imageData = UIImage.jpegData(image!)(compressionQuality: 1)

        
        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData!, withName: "file", fileName: "2.jpg",mimeType: "image/jpeg")
//            print("111图片准备上传")
//        }, to: getImageAPI()) { (encodingResult) in
//            switch encodingResult {
//            case .success(let upload,_,_):
//                upload.responseString{ response in
//                    if let data = response.data {
//                        let json = JSON(data)
//                        print(json)
//                    }
//                //获取上传进度
//                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                        print("图片上传进度: \(progress.fractionCompleted)")
//                    }
//                }
//            case .failure(_):
//                print("上传失败")
//            }
//        }
        
        
        self.imgs = imgUrl
        
        self.images.append(imgUrl)
        
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
