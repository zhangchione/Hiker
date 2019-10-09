//
//  NotesController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/24.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class NotesController: ExpandingViewController {

    public var data:NotesModel?
    
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
        button.setTitleColor(textColor, for: .normal)
        button.addTarget(self, action: #selector(achieve), for: .touchUpInside)
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
    @objc func back(){
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func achieve(){
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UIScrollViewDelegate

extension NotesController {
    
    func scrollViewDidScroll(_: UIScrollView) {
        
        self.navigation.item.title = "第" + "\(currentIndex + 1)" + "段故事"
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
            make.top.equalTo(self.navigation.bar.snp.bottom).offset(10)
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
        


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
            self.navigationController?.popToRootViewController(animated: true)
            let noteVC = NoteController()
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
        cell.photoCell.imgDatas = data.pics
        
    }
}
