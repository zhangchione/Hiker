//
//  SetViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import PopMenu
import AudioToolbox
import HandyJSON
import SwiftyJSON
import Alamofire
import ProgressHUD
import NVActivityIndicatorView

class SetViewController: SubClassBaseViewController,NVActivityIndicatorViewable {
    
    var useImg:UIImageView!
    var imgPricker:UIImagePickerController!
    var userData: UserModel?
    var requestEndFlag = false
    var headimg = UIImage()
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    
    private lazy var alterNickNameView : AlterSginView = {
        let loginView = AlterSginView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight))
        loginView.delegate = self
        return loginView
    }()
    
    @IBAction func Logout(_ sender: Any) {
                logOutApp()
    }
    
    @IBAction func cutUserImg(_ sender: Any) {
        print("头像更换")
         let actionSheet = UIAlertController(title: "更改头像", message: "请选择图像来源", preferredStyle: .actionSheet)
         let alterUserImg = UIAlertAction(title: "相册选择", style: .default, handler: {(alters:UIAlertAction) -> Void in
             print("拍照继续更改头像中..")
             
             self.imgPricker = UIImagePickerController()
             self.imgPricker.delegate = self
             self.imgPricker.allowsEditing = true
             self.imgPricker.sourceType = .photoLibrary
             
             self.imgPricker.navigationBar.barTintColor = UIColor.gray
             self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
             
             self.imgPricker.navigationBar.tintColor = UIColor.white
             
             self.present(self.imgPricker, animated: true, completion: nil)
             
         })
         
         let alterUserImgTake = UIAlertAction(title: "拍照选择", style: .default, handler: {(alters:UIAlertAction) -> Void in
             print("继续更改头像中..")
             if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                 self.imgPricker = UIImagePickerController()
                 self.imgPricker.delegate = self
                 self.imgPricker.allowsEditing = true
                 self.imgPricker.sourceType = .camera
                 self.imgPricker.cameraDevice = UIImagePickerController.CameraDevice.rear
                 self.imgPricker.showsCameraControls = true
                 
                 self.imgPricker.navigationBar.barTintColor = UIColor.gray
                 self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                 
                 self.imgPricker.navigationBar.tintColor = UIColor.white
                 
                 self.present(self.imgPricker, animated: true, completion: nil)
             }
         })
         let cancel = UIAlertAction(title: "取消", style: .cancel, handler: {(alters:UIAlertAction) -> Void in print("取消更改头像")})
         
         actionSheet.addAction(cancel)
         actionSheet.addAction(alterUserImg)
         actionSheet.addAction(alterUserImgTake)
         
         self.present(actionSheet,animated: true){
             print("正在更改")
         }
    }
    
    @IBAction func cutNickName(_ sender: Any) {
        UIApplication.shared.keyWindow?.addSubview(self.alterNickNameView)
        self.alterNickNameView.showAddView()
        
    }
    @IBAction func myLove(_ sender: Any) {
        
    }
    
    @IBAction func myCollected(_ sender: Any) {
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func faceBook(_ sender: Any) {
        
    }
    @IBAction func about(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }


    func configUI(){
        self.view.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        self.navigation.item.title = "更多"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        self.scrollView.isScrollEnabled = true
        scrollView.delegate = self
        let imgUrl = URL(string: userData!.headPic)
        self.userImg.kf.setImage(with: imgUrl)
        self.nickname.text = userData!.nickName
        
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: TKWidth, height: 1000)
    }

}

extension SetViewController : UIScrollViewDelegate {
    
}

extension SetViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("图片选取成功")
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        let imgUrl = (imageURL as! URL).path
        self.headimg = img
        self.userImg.image = self.headimg
 

        let headpic = uploadPic(imageURL: imgUrl)
        alterHeadPicNet(username: userData!.username, password: userData!.password,headPic: headpic)
            self.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SetViewController: AlterSginDelegate {
    func passBookName(with bookName: String) {
    self.nickname.text = bookName
    
    alterSginNet(username: userData!.username, password: userData!.password, nickname: bookName)
    }
    func alterSginNet(username:String,password:String,nickname:String) {
        let dic = ["username":username,"password":password,"nickName": nickname]
        
        Alamofire.request(getAlterUserInfoAPI(), method: .put, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print(json)
                print("修改成功")
            }
        }
    }
    
    func alterHeadPicNet(username:String,password:String,headPic:String) {
        let dic = ["username":username,"password":password,"headPic": headPic]
        
        Alamofire.request(getAlterUserInfoAPI(), method: .put, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print(json)
                print("头像修改成功")

                
            }
        }
    }
    
    func uploadPic(imageURL:String) -> String{

        let image = UIImage(contentsOfFile: imageURL)
        let imageData = UIImage.jpegData(image!)(compressionQuality: 1)
        var imgUrl = ""
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "2.jpg",mimeType: "image/jpeg")
            print("图片准备上传")

        }, to: getImageAPI()) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseString{ response in
                    if let data = response.data {
                        let json = JSON(data)
                        imgUrl = json["data"].stringValue
                            //self.requestEndFlag = true
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
        //self.requestEndFlag = false
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
