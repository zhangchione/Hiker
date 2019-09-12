//
//  WriteCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/12.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

// 添加按钮点击代理方法
protocol StoryWriteDelegate:NSObjectProtocol {
    func storyWriteClick(content:String,location:String,time:String)
}

class WriteCell: UITableViewCell {

    
    weak var delegate: StoryWriteDelegate?
    
    
    @IBOutlet weak var content: UITextView!
    
    @IBAction func save(_ sender: Any) {
        print(content.text,1)
        delegate?.storyWriteClick(content: content.text, location: "上海", time: "2019-9-1")
        print(content)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.content.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        public var topColor = UIColor.white
        var content1 = "快记录一下吧~"
    
    
}

extension WriteCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
        if (content.text == "快记录一下吧~") {
            content.text = ""
        }
        if self.topColor == .black {
            content.textColor = UIColor.green
        }else {
            content.textColor = UIColor.black
        }
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
        self.content1 = textView.text
        print("改变的内容为：",self.content1)

    }
    
}
