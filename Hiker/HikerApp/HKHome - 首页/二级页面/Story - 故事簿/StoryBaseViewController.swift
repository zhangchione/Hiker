//
//  StoryBaseViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

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
            self.navigation.bar.prefersLargeTitles = true
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
}

extension StoryBaseViewController {
    func configCell(_ cell:StorySementCell,with data:NoteParas) {
        cell.content.text = data.content
        cell.location.text = data.place
        cell.time.text = data.date
        let pics = data.pics.components(separatedBy: ",")
        cell.photoCell.imgDatas = pics
        //cell.photoCell.backgroundColor = .red
    }
}
