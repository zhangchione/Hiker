//
//  DeleteParasController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/23.
//  Copyright © 2019 张驰. All rights reserved.
//



import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD
import NVActivityIndicatorView

import Lightbox

class DeleteParasController: ExpandingViewController1,NVActivityIndicatorViewable {

    
    public var data:NotesModel?
    
    var note:NoteParas?
    var storyId = ""
    var bookId = 0
    var requestEndFlag = false
    
    
    convenience init(data:NotesModel) {
        self.init()
        self.data = data
    }
    lazy var userImg = UIImage()
//    var cycleScrollView:WRCycleScrollView = {
//       let cyc = WRCycleScrollView(frame: CGRect(x: 0, y: 0, width: TKWidth, height: 280))
//        return cyc
//    }()
    
    lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home_story_back")
        return iv
    }()
    lazy var userIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home_story_back")
        iv.layer.cornerRadius = 25
        return iv
    }()
    lazy var userButton: UIButton = {
            let button = UIButton()
            //button.setImage(UIImage(named: "椭圆形"), for: .normal)
            button.addTarget(self, action: #selector(use), for: .touchDown)
       //     DispatchQueue.main.async {
    //        button.corner(byRoundingCorners: [.bottomLeft,.bottomRight,.topLeft,.topRight], radii: 20)
    //        }
            return button
        }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        return label
    }()
    lazy var locationsLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        label.backgroundColor = UIColor.init(r: 46, g: 46, b: 46)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .white
         label.font = UIFont.init(name: "PingFangSC-Semibold", size: 30)
         return label
    }()
    
    
    lazy var commentBtn: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "home_detialstory_comment"), for: .normal)
        button.setBackgroundImage(UIImage(named: "home_detialstory_comment"), for: .normal)
        //button.backgroundColor = .cyan
        //button.corner(byRoundingCorners: [.bottomLeft,.bottomRight,.topLeft,.topRight], radii: 20)
        return button
    }()
    
    lazy var loveBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "home_detialstory_unfav"), for: .normal)
        //button.backgroundColor = .cyan
        //button.corner(byRoundingCorners: [.bottomLeft,.bottomRight,.topLeft,.topRight], radii: 20)
        return button
    }()
    
    lazy var hiddenBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "home_detialstory_uncollected"), for: .normal)
        //button.backgroundColor = .cyan
        //button.corner(byRoundingCorners: [.bottomLeft,.bottomRight,.topLeft,.topRight], radii: 20)
        return button
    }()
    
    lazy var noteLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.init(name: "苹方-简 常规体", size: 14)
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
        button.setImage(UIImage(named: "home_stroy_setmore"), for: .normal)
        button.addTarget(self, action: #selector(set), for: .touchUpInside)
        return button
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
        configUI()
        updateUI()
    }
    func configNav(){
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.backgroundColor = backColor
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        view.backgroundColor = backColor
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.title = ""
    }
        func updateUI(){
            print("更新UI")
            nameLabel.text = data?.user?.nickName
            titleLabel.text = data?.title
    //        userButton.setImage(UIImage(named: (viewModel.model?.user!.headPic)!), for: .normal)
            
            let imgUrl = URL(string: (data?.user!.headPic)!)
            
            self.userIcon.kf.setImage(with: imgUrl)

            let pics = data?.noteParas![0].pics.components(separatedBy: ",")
            
            let imgUrl2 = URL(string: pics![0])
            self.backgroundImageView.kf.setImage(with: imgUrl2)
            
            var locations = [String]()
            for note in (data?.noteParas!)! {
                locations.append(note.place)
            }
            let place = locations.joined(separator: "-")
            
            locationsLabel.text =  place

            
        }

    func configUI(){
        view.addSubview(backgroundImageView)
        view.addSubview(userIcon)
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(userButton)
        view.addSubview(locationsLabel)
//        self.navigation.bar.isHidden = true
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navigation.bar.snp.top).offset(-44)
            make.bottom.equalTo(self.collectionView!.snp.top).offset(-8)
            make.left.right.equalTo(view)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-25)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(TKWidth/2)
            make.height.equalTo(30)
        }
        locationsLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(130)
            make.height.equalTo(30)
        }
        userIcon.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        userButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(userIcon.snp.centerY)
            make.left.equalTo(userIcon.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        
        view.addSubview(commentBtn)
        view.addSubview(loveBtn)
        view.addSubview(hiddenBtn)
        view.addSubview(noteLabel)
        commentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.bottom.equalTo(-44)
            make.width.height.equalTo(60)
        }
        loveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.bottom.equalTo(-44)
            make.width.height.equalTo(60)
        }
        hiddenBtn.snp.makeConstraints { (make) in
            make.right.equalTo(loveBtn.snp.left).offset(-10)
            make.bottom.equalTo(-44)
            make.width.height.equalTo(60)
        }
        noteLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        if  self.data!.like {
            self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_fav"), for: .normal)
        }else {
            self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_unfav"), for: .normal)
        }
        self.loveBtn.addTarget(self, action: #selector(fav(_:)), for: .touchUpInside)
        
        if  self.data!.collected {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_collected"), for: .normal)
        }else {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_uncollected"), for: .normal)
        }
        self.hiddenBtn.addTarget(self, action: #selector(collected(_:)), for: .touchUpInside)
        self.commentBtn.addTarget(self, action: #selector(comment), for: .touchUpInside)
        
        
    }
    @objc func set(){
        let action = UIAlertController.init(title: "选项", message: "请选择您的操作", preferredStyle: .actionSheet)
         let alertY = UIAlertAction.init(title: "换种方式看游记", style: .default) { (yes) in
            let storyVC = StoryViewController(model: self.data!)
            self.navigationController?.pushViewController(storyVC, animated: true)
         }
        let alertC = UIAlertAction.init(title: "删除", style: .destructive) { (yes) in

            self.deleteNote(noteId: self.data!.id)
            
            
        }
        let alertN = UIAlertAction.init(title: "取消", style: .cancel) { (no) in
             print("取消")
         }
         
         action.addAction(alertY)
         action.addAction(alertC)
         action.addAction(alertN)
         
         self.present(action,animated: true,completion: nil)
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func achieve(){
        
    }
    @objc func use(){
        print("11")
        let userVC = HKUserViewController(data: (data?.user!)!)
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    
    
}

// MARK: UIScrollViewDelegate

extension DeleteParasController {
    
    func scrollViewDidScroll(_: UIScrollView) {

        self.noteLabel.text = "\(currentIndex + 1)/\(data!.noteParas!.count)"
        
       
    }
}

extension DeleteParasController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: NotesCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: NotesCell.self))
        
        let nib1 = UINib(nibName: String(describing: WriteNextNotesCell.self), bundle: nil)
        collectionView?.register(nib1, forCellWithReuseIdentifier: String(describing: WriteNextNotesCell.self))
        
        //collectionView?.backgroundColor = .green


    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }
}

extension DeleteParasController {
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
extension DeleteParasController {
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return (data?.noteParas!.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NotesCell.self), for: indexPath) as! NotesCell
            let cellData = data?.noteParas![indexPath.row]
            configCell(cell, with: cellData!)
            return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let para = data?.noteParas {
            showPhoto(data: para[indexPath.row])
        }
    }
//    //最小 item 间距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
//    }
}

extension DeleteParasController {
    func configCell(_ cell:NotesCell,with data:NoteParas) {
        cell.time.text = data.date
        cell.location.setTitle("#" + data.place, for: .normal)
        cell.location.addTarget(self, action: #selector(city(_:)), for: .touchUpInside)
        cell.content.text = data.content
        print(data.pics)
        let pics = data.pics.components(separatedBy: ",")
        //cell.photoCell.isLocalImage = true
        cell.photoCell.imgDatas = pics
        cell.tag1.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        cell.tag2.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        cell.tag3.setTitleColor(UIColor.init(r: 146, g: 146, b: 146), for: .normal)
        cell.tag1.backgroundColor = UIColor.init(r: 238, g: 243, b: 249)
        cell.tag2.backgroundColor = UIColor.init(r: 238, g: 243, b: 249)
        cell.tag3.backgroundColor = UIColor.init(r: 238, g: 243, b: 249)
        cell.tag1.layer.cornerRadius = 14
                cell.tag2.layer.cornerRadius = 14
                cell.tag3.layer.cornerRadius = 14
        cell.tag1.isHidden = true
        cell.tag2.isHidden = true
        cell.tag3.isHidden = true
        
        if let tag = data.tags {
        if tag.count == 1{
            cell.tag1.setTitle(tag[0].name, for: .normal)
            cell.tag1.addTarget(self, action: #selector(tag1(_:)), for: .touchUpInside)
            cell.tag1.isHidden = false
        }else if tag.count == 2{
            cell.tag1.setTitle(tag[0].name, for: .normal)
            cell.tag2.setTitle(tag[2].name, for: .normal)
                        cell.tag1.addTarget(self, action: #selector(tag1(_:)), for: .touchUpInside)
                        cell.tag2.addTarget(self, action: #selector(tag2(_:)), for: .touchUpInside)
                        cell.tag1.isHidden = false
                        cell.tag2.isHidden = false
        }else if tag.count == 3{
            cell.tag1.setTitle(tag[0].name, for: .normal)
            cell.tag2.setTitle(tag[1].name, for: .normal)
            cell.tag3.setTitle(tag[2].name, for: .normal)
            cell.tag1.addTarget(self, action: #selector(tag1(_:)), for: .touchUpInside)
            cell.tag2.addTarget(self, action: #selector(tag2(_:)), for: .touchUpInside)
            cell.tag3.addTarget(self, action: #selector(tag3(_:)), for: .touchUpInside)
                        cell.tag1.isHidden = false
                        cell.tag2.isHidden = false
                        cell.tag3.isHidden = false
            }
        }
        
    }
    
    @objc func tag1(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: NotesCell.self)!
        let indexPath = collectionView!.indexPath(for: cell)
        let word = data?.noteParas![indexPath!.row].tags![0].name
        let vc = SearchContentViewController(word: word!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tag2(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: NotesCell.self)!
        let indexPath = collectionView!.indexPath(for: cell)
        let word = data?.noteParas![indexPath!.row].tags![1].name
        let vc = SearchContentViewController(word: word!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tag3(_ sender:UIButton){
        
        let btn = sender
        let cell = btn.superView(of: NotesCell.self)!
        let indexPath = collectionView!.indexPath(for: cell)
        let word = data?.noteParas![indexPath!.row].tags![2].name
        let vc = SearchContentViewController(word: word!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func city(_ sender:UIButton) {
        let btn = sender
        let cell = btn.superView(of: NotesCell.self)!
        let indexPath = collectionView!.indexPath(for: cell)
        let word = data?.noteParas![indexPath!.row].place
        let vc = SearchContentViewController(word: word!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 图片点击
    func showPhoto(data:NoteParas){
        
        let pics = data.pics.components(separatedBy: ",")
        var imgs = [LightboxImage]()
        for pic in pics {
            
            let img = LightboxImage(imageURL: URL(string: pic)!, text: data.content)
            imgs.append(img)
        }

        let controller = LightboxController(images: imgs)
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}


// 收藏 点赞 评论 按钮事件
extension DeleteParasController {
    
    @objc func comment(){
        let vc = CommentViewController(data: data!.comments!,noteId:data!.id)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func collected(_ sender:UIButton){
        
        if data!.collected {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_uncollected"), for: .normal)
            data!.collected = false
            unCollecteNet(noteId: data!.id)
        }else {
            self.hiddenBtn.setBackgroundImage(UIImage(named: "home_detialstory_collected"), for: .normal)
            data!.collected = true
            collecteNet(noteId: data!.id)
        }
        
        
    }
    
    @objc func fav(_ sender:UIButton){

        if data!.like {
            self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_unfav"), for: .normal)
            data!.like = false
            favNet(noteId: data!.id)
        }else {
             self.loveBtn.setBackgroundImage(UIImage(named: "home_detialstory_fav"), for: .normal)
            data!.like = true
            favNet(noteId: data!.id)
            
        }
        
        
        
    }
    
    func favNet(noteId:Int) {
        
        Alamofire.request(getFavAPI(noteId: noteId)).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                    print(json)
            }
        }
    }
    
    func collecteNet(noteId:Int) {

        let dic = ["userId":getUserId()!,"noteId":noteId] as [String : Any]
        
        Alamofire.request(getCollectedAPI(noteId: noteId), method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                ProgressHUD.showError("收藏网络请求错误"); return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print(json,1)
            }
        }
    }
    
    func unCollecteNet(noteId:Int) {
        let dic = ["userId":getUserId()!,"noteId":noteId] as [String : Any]
        Alamofire.request(getUnCollectedAPI(noteId: noteId), method: .delete, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                ProgressHUD.showError("收藏网络请求错误"); return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
            }
        }
    
    }
    
    func deleteNote(noteId:Int) {
        let dic = ["noteId":noteId]
        Alamofire.request(getDeleteNoteAPI(), method: .delete, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                ProgressHUD.showError("收藏网络请求错误"); return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                ProgressHUD.showSuccess("删除成功")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
