//
//  NotesController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/24.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import NVActivityIndicatorView

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class NotesController: ExpandingViewController,NVActivityIndicatorViewable {

    
    public var data:NotesModel?
    
    var note:NoteParas?
    var storyId = ""
    var bookId = 0
    var requestEndFlag = false
    
    
    convenience init(data:NotesModel) {
        self.init()
        self.data = data
    }
    
    // 标题
    lazy var storyTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "魔都上海两日"
        label.textColor = UIColor.black
        //label.backgroundColor = .cyan
        return label
    }()
    
    // 底部设置按钮
    private lazy var setButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setTitle("设置", for: .normal)
        button.addTarget(self, action: #selector(set), for: .touchUpInside)
        return button
    }()
    
    // 左边返回按钮
    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:10, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "home_icon_back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    /// 右边预览按钮
    private lazy var rightBarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x:-10, y:0, width:30, height: 30)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(achieve), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginView : HiddenView = {
        let loginView = HiddenView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight))
        
        var bookData = [BookModel]()
        let bookid = getBookId()
        let bookname = getBookName()
        let booknum = getBookNum()
        
        var bookmodel = BookModel()
        for index in 0 ..< bookid!.count {

            bookmodel.name = bookname![index]
            bookmodel.id = bookid![index]
            bookmodel.num = booknum![index]
            bookData.append(bookmodel)
        }
        loginView.data = bookData
        loginView.delegate = self
        return loginView
    }()
    
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate let items: [ItemInfo] = [("item0", "Boston"), ("item1", "New York"), ("item2", "San Francisco"), ("item3", "Washington")]
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 374, height: 600)
        super.viewDidLoad()
        registerCell()
        fillCellIsOpenArray()
        configNav()
        
    }
    

    func configNav(){
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.backgroundColor = backColor
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        view.backgroundColor = backColor
        self.navigation.bar.isShadowHidden = true
//        self.navigation.bar.isHidden = true
        self.navigation.item.title = "第一段故事"
    }
    @objc func set(){
        
    }
    
    @objc func back(){
        var c1 = getContent()
        var c2 = getLocation()
        var c3 = getTime()
        var c4 = getPic()
        c1?.removeLast()
        c2?.removeLast()
        c3?.removeLast()
        c4?.removeLast()
        
        if c1 != nil {
            saveContent(content: c1!)
            saveLocation(location: c2!)
            saveTime(content: c3!)
            savePic(content: c4!)
        }
        
        print(c1)
        print(c2)
        print(c3)
        print(c4)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func achieve(){
        
        UIApplication.shared.keyWindow?.addSubview(self.loginView)
        
        self.loginView.showAddView()
        
    }
    
}

// MARK: UIScrollViewDelegate

extension NotesController {
    
    func scrollViewDidScroll(_: UIScrollView) {
        
        if currentIndex == (data?.noteParas!.count)! {
             self.navigation.item.title = "开启下一段故事"
        } else {
             self.navigation.item.title = "第" + "\(currentIndex + 1)" + "段故事"
        }
        
       
    }
}

extension NotesController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: NotesCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: NotesCell.self))
        
        let nib1 = UINib(nibName: String(describing: WriteNextNotesCell.self), bundle: nil)
        collectionView?.register(nib1, forCellWithReuseIdentifier: String(describing: WriteNextNotesCell.self))
        
        //collectionView?.backgroundColor = .green
        view.addSubview(storyTitle)
        storyTitle.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            if TKWidth >= 812 {
            make.top.equalTo(self.navigation.bar.snp.bottom).offset(30)
            }else {
                        make.top.equalTo(self.navigation.bar.snp.bottom).offset(0)
            }
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
        storyTitle.text = getTitle()!


    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }
}

extension NotesController {
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
//        guard let cell = cell as? NotesCell else { return }
//
//        let index = indexPath.row % items.count
//        let info = items[index]
////        cell.backgroundImageView?.image = UIImage(named: info.imageName)
////        cell.customTitle.text = info.title
//        cell.cellIsOpen(cellsIsOpen[index], animated: false)
//        //cell.btn.addTarget(self, action: #selector(add), for: .touchUpInside)
//    }
}
extension NotesController {
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return (data?.noteParas!.count)! + 1
    } 
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NotesCell.self), for: indexPath) as! NotesCell
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WriteNextNotesCell.self), for: indexPath)
        if indexPath.row == (data?.noteParas!.count)!   {
            
            return cell1
            
        }else {
            let cellData = data?.noteParas![indexPath.row]
            configCell(cell, with: cellData!)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row ==  (data?.noteParas!.count)! {
           // self.navigationController?.popToRootViewController(animated: true)
                var app = AppContext()
            let noteVC = NoteController()
            //let noteVC = NoteController()
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
    }
//    //最小 item 间距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
//    }
}

extension NotesController {
    func configCell(_ cell:NotesCell,with data:NoteParas) {
        cell.time.text = data.date
        cell.location.text = data.place
        cell.content.text = data.content
        print(data.pics)
        let pics = data.pics.components(separatedBy: ",")
        //cell.photoCell.isLocalImage = true
        cell.photoCell.imgDatas = pics
    }
}

extension NotesController {
    func postStory(title:String) {
        let dic = ["title":title]
        Alamofire.request(getStoryAPI(), method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                self.storyId = json["data"]["id"].stringValue
                self.requestEndFlag = true
            }
        }
        waitingRequestEnd()
        self.requestEndFlag =  false
        print("游记id获取成功,发布成功")
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
                        self.requestEndFlag = true
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
        waitingRequestEnd()
        self.requestEndFlag = false
        print("图片上传完成")
        return imgUrl
    }
    func postNotes(note:NoteParas,pic:String) {
        print("正在进行游记写入")
        let dic = ["content":note.content,"pics":pic,"date": note.date,"place":note.place,"noteId":storyId]
        
        Alamofire.request(getNotesAPI(), method: .put, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("发布游记网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                self.requestEndFlag = true
            }
        }
        waitingRequestEnd()
        self.requestEndFlag =  false
        
    }
    
    // 创建故事簿
    func postNewBookName(bookname:String) {
        let dic = ["bookName":bookname]
        Alamofire.request(getNewBookAPI(), method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                self.bookId = json["data"]["id"].intValue
                self.requestEndFlag = true
            }
        }
        waitingRequestEnd()
        self.requestEndFlag =  false
        print("故事本创建成功")
    }
    
    // 收录到故事簿
    func putBookName(bookid:Int) {
        let dic = ["noteId":storyId,"groupId":bookid] as [String : Any]
        
        Alamofire.request(getHiddenBookNameAPI(), method: .put, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("发布游记网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                self.requestEndFlag = true
                
            }
        }
        waitingRequestEnd()
        self.requestEndFlag =  false
        print("收录成功")
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
    func removeUserDeault() {
        UserDefaults.standard.removeObject(forKey: "content")
        UserDefaults.standard.removeObject(forKey: "time")
        UserDefaults.standard.removeObject(forKey: "pic")
        UserDefaults.standard.removeObject(forKey: "location")
        
    }
    
}

extension NotesController: selectBookDelegate {
    func passBookData(with name: String, id: Int) {
        print(name,id)
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "发布游记中...", type: .ballClipRotate, fadeInAnimation: nil)
        postStory(title: getTitle()!)
        
        if id != 0 {
            putBookName(bookid: id)
            
        }else {
            postNewBookName(bookname: name)
            putBookName(bookid: bookId)
        }
        
         saveFlag(flag: "001")

         for index in 0 ..< (data?.noteParas!.count)! {
             print(index,self.data?.noteParas![index].pics)
             var imgs = self.data?.noteParas![index].pics
//             let imgsArray = self.data?.noteParas![index].pics.components(separatedBy:",")
//             for img in imgsArray! {
//                 print(img)
//                 if imgs != "" {
//                     imgs = imgs + "," + uploadPic(imageURL: img)
//                 }else {
//                     imgs = uploadPic(imageURL: img)
//                 }
//             }
//
             self.note = self.data?.noteParas![index]

            postNotes(note: self.note!, pic: imgs!)
         }
         removeUserDeault()
        NVActivityIndicatorPresenter.sharedInstance.setMessage("发布完成...")
        
         self.navigationController?.popToRootViewController(animated: true)
        self.stopAnimating(nil)
    }
    
}
