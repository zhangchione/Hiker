//
//  TitleController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/24.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class TitleController: UIViewController {

    @IBOutlet weak var textView: UITextView!
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
        button.setTitle("预览", for: .normal)
        button.setTitleColor(textColor, for: .normal)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
        configCV()
    }
    
    
    func configNav(){
        self.navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigation.bar.backgroundColor = backColor
        self.navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        view.backgroundColor = backColor
        self.navigation.bar.isShadowHidden = true
        self.navigation.item.title = "写故事"
    }
    func configCV(){
        self.textView.delegate = self
    }
    
    @objc func back(){
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addStory(_ sender: UIButton) {
        saveTitle(title: textView.text)
        let noteVC = NoteController()
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
    
}
extension TitleController:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
            if (content.text == "故事标题") {
                content.text = ""
                content.textColor = .gray
            }else {
                content.textColor = UIColor.black
            }
            return true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
