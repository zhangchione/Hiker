//
//  TitleViewController.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/20.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {

    lazy var diaryWirte : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 28)
        tv.textColor = UIColor.black
        tv.delegate = self
        tv.text = "故事标题"
        return tv
    }()
    
    lazy var startBtn:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("开始写游记", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(start), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        
    }
    
    func setUpUI(){
        view.backgroundColor = .white
        view.addSubview(self.diaryWirte)
        view.addSubview(startBtn)
        self.diaryWirte.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY)
            make.left.equalTo(20)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        startBtn.snp.makeConstraints { (make) in
            make.top.equalTo(diaryWirte.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
    }
    @objc func start(){
        saveTitle(title: diaryWirte.text)
        let noteVC = NoteViewController()
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
    var topColor = UIColor.black
    
}

extension TitleViewController:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
            if (content.text == "故事标题") {
                content.text = ""
            }
            if self.topColor == .black {
                content.textColor = UIColor.green
            }else {
                content.textColor = UIColor.black
            }
            return true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
