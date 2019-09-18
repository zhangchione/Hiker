//
//  HKMineViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import LTScrollView
import PopMenu
import AudioToolbox

private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

class HKMineViewController: UIViewController {

    lazy var addStoryBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .cyan
        return btn
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        let oneVc = MineStoryViewController()
        let twoVc = MineStoryViewController()
        twoVc.count = 5
        let threeVc = MineStoryViewController()
        threeVc.count = 6
        let fourVc = MineStoryViewController()
                fourVc.count = 3
        return [oneVc, twoVc, threeVc, fourVc]
    }()
    
    private lazy var titles: [String] = {
        return ["全部", "暑假之旅", "澳洲", "上海"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = false
        layout.titleViewBgColor = .white
        layout.titleSelectColor = UIColor.init(r: 0, g: 0, b: 0)
        layout.bottomLineColor = UIColor.init(r: 64, g: 223, b: 238)
        layout.sliderHeight = 48
        layout.lrMargin = 20
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        print(statusBarH)
        let Y: CGFloat = statusBarH + 88
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y ) : view.bounds.height - Y
        return CGRect(x: 0, y: statusBarH, width: view.bounds.width, height: H)
    }
    
    
    private lazy var advancedManager: LTAdvancedManager = {
        let advancedManager = LTAdvancedManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.headerView
            return headerView
        })
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self
        
         //设置悬停位置
         advancedManager.hoverY = 44
        
        /* 点击切换滚动过程动画 */
                advancedManager.isClickScrollAnimation = true
        
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        
        return advancedManager
    }()
    
    
    // MARK - 右边功能按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: .custom)
         button.frame = CGRect(x:10, y:0, width:40, height: 40)
        button.addTarget(self, action: #selector(set), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "mine_icon_set"), for: .normal)
        //button.backgroundColor = UIColor.red
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // MARK - 右边功能按钮
    private lazy var addBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        //button.frame = CGRect(x:10, y:0, width:40, height: 40)
        button.addTarget(self, action: #selector(set), for: UIControl.Event.touchUpInside)
        button.setTitle("添加故事本", for: .normal)
        //button.setImage(UIImage(named: "mine_icon_set"), for: .normal)
        //button.backgroundColor = UIColor.red
        return button
    }()
    
    func configUI(){
        if #available(iOS 11.0, *) {
            self.navigation.bar.prefersLargeTitles = false
        }
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        //self.navigation.item.title = "王一一"
        //advancedManager.backgroundColor = .red
        view.addSubview(advancedManager)
        self.navigation.bar.backgroundColor = .white
        self.view.backgroundColor = .white
        advancedManagerConfig()
        
//        self.view.addSubview(addStoryBtn)
//        addStoryBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(view.snp.right).offset(20)
//            make.width.equalTo(50)
//            make.top.equalTo(headerView.snp.bottom).offset(8)
//            make.height.equalTo(30)
//        }
//        addStoryBtn.addTarget(self, action: #selector(addStory), for: .touchUpInside)
    }

    lazy var headerView:MineHeaderView = {
        let headerView = MineHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: AdaptH(320)))
        
        let alterBackImgTap = UILongPressGestureRecognizer(target: self, action: #selector(alterBackImg))
        //headerView.backgroundImageView
        headerView.backgroundImageView.addGestureRecognizer(alterBackImgTap)
        headerView.alterBtn.addTarget(self, action: #selector(alterUserSign), for: .touchUpInside)
        headerView.storyBtn.addTarget(self, action: #selector(story), for: .touchUpInside)
        headerView.fanBtn.addTarget(self, action: #selector(fan), for: .touchUpInside)
        headerView.concernBtn.addTarget(self, action: #selector(concern), for: .touchUpInside)
        
        return headerView
    }()
    
    
        var imgPricker:UIImagePickerController!
    

}
extension HKMineViewController: LTAdvancedScrollViewDelegate {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
        advancedManager.advancedDidSelectIndexHandle = {
            print("选中了 -> \($0)")
        }
        
    }
    
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        print("offset --> ", offsetY)
        if offsetY >= 260 {
            self.navigation.bar.alpha = 1
            self.navigation.item.title = "王一一"
            self.rightBarButton.setImage(UIImage(named: "mine_icon_setblack"), for: .normal)
        }
        else {
            self.navigation.bar.alpha = 0
            self.navigation.item.title = ""
            self.rightBarButton.setImage(UIImage(named: "mine_icon_set"), for: .normal)
        }
    }
}

// - MARK: 事件
extension HKMineViewController {
    @objc func alterBackImg() {
        print("改背景")
        
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.prepare()
        feedback.impactOccurred()
        
        let action = UIAlertController.init(title: "修改背景", message: "您是否确定要修改背景图片？", preferredStyle: .actionSheet)
        let alertY = UIAlertAction.init(title: "修改", style: .destructive) { (yes) in
            print("确定修改")
            self.imgPricker = UIImagePickerController()
            self.imgPricker.delegate = self
            self.imgPricker.allowsEditing = true
            self.imgPricker.sourceType = .photoLibrary
            
            self.imgPricker.navigationBar.barTintColor = UIColor.gray
            self.imgPricker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            
            self.imgPricker.navigationBar.tintColor = UIColor.white
            
            self.present(self.imgPricker, animated: true, completion: nil)
            
        }
        let alertN = UIAlertAction.init(title: "取消", style: .cancel) { (no) in
            print("取消")
        }
        
        action.addAction(alertY)
        action.addAction(alertN)
        
        self.present(action,animated: true,completion: nil)
        
        
        
    }

    @objc func alterUserSign() {
        
        print("改签名")
    }
    @objc func story() {
        
        print("我的游记")
    }
    @objc func fan() {
        
        print("我的粉丝")
        let fanVC = FanViewController()
        self.navigationController?.pushViewController(fanVC, animated: true)
    }
    @objc func concern() {
        
        print("我的关注")
        let concernVC = ConcernViewController()
        self.navigationController?.pushViewController(concernVC, animated: true)
    }
    
    @objc func set() {
        print("右边按钮")
        let setVC = SetViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    
    @objc func addStory(){
        print("添加故事簿")
    }
}
extension HKMineViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("图片选取成功")
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]!
        let imageData1 = try! Data(contentsOf: imageURL as! URL)
        //self.img.image = img
        
       self.headerView.backgroundImageView.image = UIImage(data: imageData1)

        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
