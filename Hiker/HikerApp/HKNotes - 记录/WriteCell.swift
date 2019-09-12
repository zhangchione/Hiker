//
//  WriteCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/12.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit



class WriteCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var next1: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            content.textColor = UIColor.black
        }else {
            content.textColor = UIColor.white
        }
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
        self.content1 = textView.text
        print("改变的内容为：",self.content1)

    }
    
}
