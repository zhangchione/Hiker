//
//  HKMineViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/9.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import LTScrollView
private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

class HKMineViewController: UIViewController {

    private lazy var viewControllers: [UIViewController] = {
        let oneVc = LTAdvancedTestOneVC()
        let twoVc = LTAdvancedTestOneVC()
        twoVc.count = 5
        let threeVc = LTAdvancedTestOneVC()
        let fourVc = LTAdvancedTestOneVC()
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
            let headerView = strongSelf.testLabel()
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
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        //self.navigation.item.title = "王一一"
        //advancedManager.backgroundColor = .red
        view.addSubview(advancedManager)
        self.navigation.bar.backgroundColor = .white
        self.view.backgroundColor = .white
        advancedManagerConfig()
    }

    private func testLabel() -> MineHeaderView {
        return MineHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 350))
    }
    @objc func set() {
        print("右边按钮")
        let setVC = SetViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
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
        }
        else {
            self.navigation.bar.alpha = 0
            self.navigation.item.title = ""
        }
    }
}
