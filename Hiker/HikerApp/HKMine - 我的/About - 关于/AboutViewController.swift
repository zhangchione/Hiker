//
//  AboutViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/10/15.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import ProgressHUD

class AboutViewController: SubClassBaseViewController {
    
    @IBAction func commentScore(_ sender: Any) {
//        let url = URL(string: "itms-apps://itunes.apple.com/")
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        let fbVC = FaceBookViewController()
        self.navigationController?.pushViewController(fbVC, animated: true)
    }
    
    @IBAction func function(_ sender: Any) {
        if let url = URL(string: "https://shimo.im/docs/VrWVWKCPVC9hKQpV") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func team(_ sender: Any) {
        let teamVC = TeamViewController()
        self.navigationController?.pushViewController(teamVC, animated: true)
        
    }
    
    @IBAction func newVersion(_ sender: Any) {
            ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        }
        ProgressHUD.showSuccess("已是最新版本")
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.isScrollEnabled = true
        scrollView.delegate = self
        configUI()
    }

    func configUI() {
        self.navigation.item.title = "关于"
        self.navigation.bar.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        view.backgroundColor = backColor
    }

    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: TKWidth, height: TKHeight-88)
    }

}
extension AboutViewController : UIScrollViewDelegate {
    
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

}
