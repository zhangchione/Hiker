//
//  WriteStoryCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/12.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// 添加按钮点击代理方法
protocol WriteStoryDelegate:NSObjectProtocol {
    func storyWriteClick(content:String,location:String,time:String)
}


class WriteStoryCell: UITableViewCell {

    weak var delegate: WriteStoryDelegate?
    
    public var isAddPhoto = false
    
    lazy var writeTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = UIColor.init(r: 204, g: 204, b: 204  )
        tv.text = "以段落的形式分享您旅途中印象深刻的故事、有趣的体验，行迹将帮助您从系统相册中匹配图片发表游记。"
        return tv
    }()
    
    lazy var locationBtn:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_location"), for: .normal)
        btn.setTitle("添加地点", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "note_icon_location"), for: .normal)
        btn.setTitle("添加时间", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    lazy var nextBtn:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("下一段", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.init(r: 64, g: 102, b: 214)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var onePhoto:OnePhotoCell = {
       let cell = OnePhotoCell()
        return cell
    }()
    
    
    // 图片
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "note_icon_location")
        return imageView
    }()
    // 标题
    lazy var location: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "地点"
        label.textColor = UIColor.white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setUpUI()
        self.writeTextView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpUI(){
        
        addSubview(writeTextView)
        addSubview(locationBtn)
        addSubview(timeBtn)
        addSubview(nextBtn)
        
        writeTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        locationBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        timeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(160)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(timeBtn.snp.bottom).offset(25)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }

    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var topColor = UIColor.black
    
    func updateUI(height:Double){
        if height < 130 {
        self.writeTextView.snp.remakeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(height)
        }
        
        locationBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        timeBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(writeTextView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(160)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(timeBtn.snp.bottom).offset(25)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        }
    }
    func updatePhoto(){
        addSubview(onePhoto)
        onePhoto.snp.makeConstraints { (make) in
            make.top.equalTo(locationBtn.snp.bottom).offset(5)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(130)
        }
        print("增加图片")
//        nextBtn.snp.remakeConstraints { (make) in
//            make.top.equalTo(onePhoto.snp.bottom).offset(15)
//            make.right.equalTo(self).offset(-20)
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//        }
    }
    
    var cellPhotoDatas:String? {
        didSet{
            guard let photo = cellPhotoDatas else {
                return
            }
            self.onePhoto.photoDatas = photo
        }
    }
    
}
extension WriteStoryCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ content: UITextView) -> Bool {
        if (content.text == "以段落的形式分享您旅途中印象深刻的故事、有趣的体验，行迹将帮助您从系统相册中匹配图片发表游记。") {
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
       // self.content1 = textView.text
        print("改变的内容为：",textView.text)
        var textHeight = getTextHeigh(textStr: textView.text!, font: UIFont.systemFont(ofSize: 16), width: 374) + 20
        print("高度为：",textHeight)
        updateUI(height: Double(textHeight))
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("结束编辑")
    }
    
}
extension WriteStoryCell {
    // 获取 content 高度
    fileprivate func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size,options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedString.Key : Any] , context:nil).size
        return stringSize.height
    }
    @objc func nextClick(){
        self.isAddPhoto = true
        updatePhoto()
        delegate?.storyWriteClick(content: writeTextView.text!, location: "上海", time: "2019-09-12")
        print("下一段点击")
    }
}
