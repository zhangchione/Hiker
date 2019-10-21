//
//  MineStoryViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import MJRefresh
import LTScrollView


class MineStoryViewController: UIViewController {
    public var count = 10
    public var datas:[NotesModel]?
    
    private let storyID = "MineSotryCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: storyID, bundle: nil), forCellReuseIdentifier: storyID)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        reftreshData()
    }
    override func viewWillAppear(_ animated: Bool) {
//                super.viewWillAppear(animated)
//        //        key1: reload Data here
//        tableView.reloadData()
//        //        key2: do the animation in ViewwillApear,not in delegate "willDisplay", that will case reuse cell problem!
//        let cells = tableView.visibleCells
//        let tableHeight: CGFloat = tableView.bounds.size.height
//
//        for (index, cell) in cells.enumerated() {
//            //            use origin.y or CGAffineTransform and set y has same effect!
//            //            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
//            cell.frame.origin.y = tableHeight
//            UIView.animate(withDuration: 0.5, delay: 0.04 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//                //                cell.transform = CGAffineTransform(translationX: 0, y: 0);
//                cell.frame.origin.y = 0
//            }, completion: nil)
//        }
    }
    
    func configUI(){
        view.addSubview(self.tableView)
        self.tableView.frame = CGRect(x: 0, y: 0, width: TKWidth, height: TKHeight - 120)
        glt_scrollView = tableView
        glt_scrollView?.showsVerticalScrollIndicator = false
    }

}

extension MineStoryViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return datas!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: storyID, for: indexPath) as! MineSotryCell
            
            configCell(cell, with: datas![indexPath.row])
            
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return  100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("111")
        let model = datas![indexPath.row]
        let vc = StoryViewController(model: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MineStoryViewController{
    
    func configCell(_ cell:MineSotryCell,with data:NotesModel){
        
        let pics = data.noteParas![0].pics.components(separatedBy: ",")
        let imgUrl = URL(string: pics[0])
        cell.img.kf.setImage(with: imgUrl)
        cell.time.text = data.noteParas![0].date
        cell.title.text = data.title

        var locations = [String]()
        for note in data.noteParas! {
            locations.append(note.place)
        }
        let place = locations.joined(separator: "、")
        cell.locations.text = "#" + place
        
        if data.type == 2 {
            cell.personal.isHidden = true
        }
    }
    fileprivate func reftreshData()  {
        
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("上拉加载更多数据")
                self?.tableView.mj_footer.endRefreshing()
            })
        }
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("下拉刷新 --- 1")
                self?.tableView.mj_header.endRefreshing()
            })
        }
    }
    
}
