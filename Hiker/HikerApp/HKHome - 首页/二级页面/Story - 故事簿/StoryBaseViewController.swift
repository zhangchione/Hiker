//
//  StoryBaseViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import Lightbox


class StoryBaseViewController: UIViewController {

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
    
    let str = "下了飞机第一件事是去地铁的人工窗口办一张三日卡，只需要45元，72小时内可以无限制乘坐地铁，能大大节约每次购票的时间和金钱，非常划算，毕竟，上海绝大部分地方，都是可以通过地铁达到的。另外，推荐下载“上海地铁”APP，能够方便查询线路等信息，便于高效换乘。"
    private let StorySementCellID = "StorySementCell"
    
    public var paras: [NoteParas]?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StorySementCell.self, forCellReuseIdentifier: StorySementCellID)
        tableView.separatorStyle = .none

        return tableView
    }()
    let rowNumber = 6
    let rowHeight: CGFloat = 200
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view)
            make.width.equalTo(TKWidth)
            make.height.equalTo(TKHeight)
        }
        view.addSubview(commentBtn)
        view.addSubview(loveBtn)
        view.addSubview(hiddenBtn)
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
        
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = false
           // self.navigation.item.largeTitleDisplayMode = .automatic
        }


    }
    

    

}

extension StoryBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return paras!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: StorySementCellID , for: indexPath) as! StorySementCell
                cell.selectionStyle = .none;
            if let para = paras {
                configCell(cell, with: paras![indexPath.row])
            }
                cell.num.text = "0\(indexPath.row + 1)"
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight =  CGFloat(self.getTextHeigh(textStr: str, font: UIFont.boldSystemFont(ofSize: 15), width: 374))
        return cellHeight + 290
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("111")
        if let para = paras {
            showPhoto(data: para[indexPath.row])
        }
    }
}

extension StoryBaseViewController {
    // 获取 content 高度
    fileprivate func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size,options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedString.Key : Any] , context:nil).size
        return stringSize.height
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

extension StoryBaseViewController {
    func configCell(_ cell:StorySementCell,with data:NoteParas) {
        cell.content.text = data.content
        cell.location.text = "#" + data.place
        cell.time.text = data.date
        let pics = data.pics.components(separatedBy: ",")
        cell.photoCell.imgDatas = pics
        //cell.photoCell.backgroundColor = .red
        cell.locationBtn.addTarget(self, action: #selector(city(_:)), for: .touchUpInside)
        
    }
    
    @objc func city(_ sender: UIButton) {
        let btn = sender
        let cell = btn.superView(of: StorySementCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        
        let data = paras![indexPath!.row].place
        let vc = SearchContentViewController(word: data)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoryBaseViewController {
    /// 截屏
       ///
       /// - Parameters:
       ///   - view: 要截屏的view
       /// - Returns: 一个UIImage
       func cutImageWithView(view:UIView) -> UIImage
       {
           // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
           UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
           view.layer.render(in: UIGraphicsGetCurrentContext()!)
           let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext();
           return image;
       }
       func writeImageToAlbum(image:UIImage)
       {
           UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
       }
       @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer)
       {
           if let e = error as NSError?
           {
               print(e)
           }
           else
           {
                print("保存成功")
               UIAlertController.init(title: nil,
                                      message: "保存成功！",
                                      preferredStyle: UIAlertController.Style.alert).show(self, sender: nil);
           }
       }
       
            /// 截长屏
           ///
           /// - Parameters:
           ///   - view: 要截屏的view
           /// - Returns: 一个UIImage
           func cutFullImageWithView(scrollView:UIScrollView) -> UIImage
           {
               // 记录当前的scrollView的偏移量和坐标
               let currentContentOffSet:CGPoint = scrollView.contentOffset
               let currentFrame:CGRect = scrollView.frame;
               
               // 设置为zero和相应的坐标
               scrollView.contentOffset = CGPoint.zero
               scrollView.frame = CGRect.init(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
               
               // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
               UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
               scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
               let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
               
               // 重新设置原来的参数
               scrollView.contentOffset = currentContentOffSet
               scrollView.frame = currentFrame
               
               UIGraphicsEndImageContext();
               
               return image;
           }
    
    func combinTwoImage(image1:UIImage,image2:UIImage) -> UIImage
    {
        let width = max(image1.size.width, image2.size.width)
        let height = image1.size.height + image2.size.height
        let offScreenSize = CGSize.init(width: width, height: height)
        
        UIGraphicsBeginImageContext(offScreenSize);
        
        let rect = CGRect.init(x:0, y:0, width:width, height:image1.size.height)
        image1.draw(in: rect)
        
        let rect2 = CGRect.init(x:0, y:image1.size.height, width:width, height:image2.size.height)
        image1.draw(in: rect2)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}
