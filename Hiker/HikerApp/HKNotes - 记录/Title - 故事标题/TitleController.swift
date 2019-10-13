//
//  TitleController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/24.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

import ProgressHUD

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
    
    var dismissKetboardTap = UITapGestureRecognizer()
    

    
    @objc func dismissKeyboard(){
        print("键盘成功关闭")
        self.view.endEditing(false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNav()
        configCV()
        UserDefaults.standard.removeObject(forKey: "content")
        UserDefaults.standard.removeObject(forKey: "time")
        UserDefaults.standard.removeObject(forKey: "pic")
        UserDefaults.standard.removeObject(forKey: "location")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if getFlag() == "001" {
            self.dismiss(animated: true, completion: nil)
                    UserDefaults.standard.removeObject(forKey: "flag")
        }else {
        
        let c1 = getContent()
        let c2 = getLocation()
        let c3 = getTime()
        let c4 = getPic()
        if c1 == nil {
            
        }else {
            rightBarButton.setTitleColor(UIColor.red, for: .normal)
            rightBarButton.addTarget(self, action: #selector(look), for: .touchUpInside)
        }
        }
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
        dismissKetboardTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKetboardTap)
    }
    
    @objc func back(){
       self.dismiss(animated: true, completion: nil)
    }
    // 数据
    var datas = NotesModel()
    
    @objc func look() {

//        if c1 == nil {
//            ProgressHUD.showError("暂无段落")
//        }else {
//        var paras = [NoteParas]()
//        var para = NoteParas()
//        for index in 0 ..< c1!.count {
//            para.content = c1![index]
//            para.date = c3![index]
//            para.pics = c4![index]
//            para.place = c2![index]
//            paras.append(para)
//
//        }
//        datas.noteParas = paras
//        let noteVC = NotesController(data: datas)
//        self.navigationController?.pushViewController(noteVC, animated: true)
//        }
    }
    
    @IBAction func addStory(_ sender: UIButton) {
        
        if textView.text == "故事标题" {
            
            ProgressHUD.showError("请添加故事标题")
            
        }else {
            saveTitle(title: textView.text)
            let noteVC = NoteController()
            self.navigationController?.pushViewController(noteVC, animated: true)
        }

    }
    
}
extension TitleController:UITextViewDelegate {
    
        func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
            if (content.text == "故事标题") {
                content.text = ""
                content.textColor = .gray
            }else {
                content.textColor = UIColor.black
            }
            return true
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "故事标题"
            textView.textColor = .gray
        }
    }
}
