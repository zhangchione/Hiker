//
//  PhotoCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/23.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PhotoCell: UIView {

    // 图片1
    lazy var img1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 图片2
    lazy var img2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 图片3
    lazy var img3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 图片4
    lazy var img4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 图片5
    lazy var img5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        return imageView
    }()
    
    // 图片6
    lazy var img6: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_story_back")
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imgDatas:[String]? {
        didSet{
            guard let imgdatas = imgDatas else { return }
            self.updateUI(imgdatas.count,with: imgdatas)
        }
    }
    var imgsUIImage:[UIImage]? {
        didSet{
            guard let imgs = imgsUIImage else { return }
            self.updateUILocal(imgs.count,with: imgs)
        }
    }
    
    var isLocalImage = false
    
    
    func updateUI(_ count:Int,with data:[String]) {
        switch count {
        case 1:
            DispatchQueue.main.async {
                self.img1.corner(byRoundingCorners: [.topLeft , .topRight], radii: 10)

                if self.isLocalImage {
                    self.img1.image = UIImage(contentsOfFile: data[0])
                }else {
                    let imgUrl = URL(string: data[0])
                    self.img1.kf.setImage(with: imgUrl)
                    
                }
                
            }
            img1.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.bottom.equalTo(self)
                make.right.equalTo(self)
            }
        case 2:
            DispatchQueue.main.async {
                self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                self.img2.corner(byRoundingCorners: .topRight, radii: 10)
                
                if self.isLocalImage {
                    self.img1.image = UIImage(contentsOfFile: data[0])
                    self.img2.image = UIImage(contentsOfFile: data[1])
                }else {
                   
                    let imgUrl = URL(string: data[0])
                    self.img1.kf.setImage(with: imgUrl)
                    let imgUrl2 = URL(string: data[1])
                    self.img2.kf.setImage(with: imgUrl2)
                    
                }

                
            }
            img1.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.bottom.equalTo(self)
                make.right.equalTo(self.snp.centerX).offset(-2.5)
            }
            img2.snp.makeConstraints { (make) in
                make.top.right.equalTo(self)
                make.bottom.equalTo(self)
                make.left.equalTo(self.snp.centerX).offset(2.5)
            }

        case 3:
            DispatchQueue.main.async {
                self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                self.img2.corner(byRoundingCorners: .topRight, radii: 10)
                if self.isLocalImage {
                    self.img1.image = UIImage(contentsOfFile: data[0])
                    self.img2.image = UIImage(contentsOfFile: data[1])
                    self.img3.image = UIImage(contentsOfFile: data[2])
                }else {
                    let imgUrl = URL(string: data[0])
                    self.img1.kf.setImage(with: imgUrl)
                    let imgUrl2 = URL(string: data[1])
                    self.img2.kf.setImage(with: imgUrl2)
                    let imgUrl3 = URL(string: data[2])
                    self.img3.kf.setImage(with: imgUrl3)
                }


            }
            img1.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.bottom.equalTo(self)
                make.right.equalTo(self.snp.centerX).offset(-2.5)
            }
            img2.snp.makeConstraints { (make) in
                make.top.right.equalTo(self)
                make.bottom.equalTo(img1.snp.centerY).offset(-2.5)
                make.left.equalTo(self.snp.centerX).offset(2.5)
            }
            img3.snp.makeConstraints { (make) in
                make.bottom.right.equalTo(self)
                make.top.equalTo(img1.snp.centerY).offset(2.5)
                make.left.equalTo(self.snp.centerX).offset(2.5)
            }
            

        case 4:
            DispatchQueue.main.async {
                self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                self.img2.corner(byRoundingCorners: .topRight, radii: 10)
                

                if self.isLocalImage {
                    self.img1.image = UIImage(contentsOfFile: data[0])
                    self.img2.image = UIImage(contentsOfFile: data[1])
                    self.img3.image = UIImage(contentsOfFile: data[2])
                    self.img4.image = UIImage(contentsOfFile: data[3])
                }else {
                    let imgUrl = URL(string: data[0])
                    self.img1.kf.setImage(with: imgUrl)
                    let imgUrl2 = URL(string: data[1])
                    self.img2.kf.setImage(with: imgUrl2)
                    let imgUrl3 = URL(string: data[2])
                    self.img3.kf.setImage(with: imgUrl3)
                    let imgUrl4 = URL(string: data[3])
                    self.img4.kf.setImage(with: imgUrl4)
                }
            }
            
            img1.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.bottom.equalTo(self)
                make.right.equalTo(self.snp.centerX).offset(-2.5)
            }
            img2.snp.makeConstraints { (make) in
                make.top.right.equalTo(self)
                make.bottom.equalTo(img1.snp.centerY).offset(-2.5)
                make.left.equalTo(self.snp.centerX).offset(2.5)
            }
            img3.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(self.snp.centerX).offset(2.5)
                make.top.equalTo(img1.snp.centerY).offset(2.5)
                make.right.equalTo(img2.snp.centerX).offset(0)
            }
            img4.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(img2.snp.centerX).offset(2.5)
                make.top.equalTo(img1.snp.centerY).offset(2.5)
                make.right.equalTo(self)
            }
            
            case 5:
                        DispatchQueue.main.async {
                            self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                            self.img3.corner(byRoundingCorners: .topRight, radii: 10)
                            

                            if self.isLocalImage {
                                self.img1.image = UIImage(contentsOfFile: data[0])
                                self.img2.image = UIImage(contentsOfFile: data[1])
                                self.img3.image = UIImage(contentsOfFile: data[2])
                                self.img4.image = UIImage(contentsOfFile: data[3])
                                self.img5.image = UIImage(contentsOfFile: data[4])
                            }else {
                                let imgUrl = URL(string: data[0])
                                self.img1.kf.setImage(with: imgUrl)
                                let imgUrl2 = URL(string: data[1])
                                self.img2.kf.setImage(with: imgUrl2)
                                let imgUrl3 = URL(string: data[2])
                                self.img3.kf.setImage(with: imgUrl3)
                                let imgUrl4 = URL(string: data[3])
                                self.img4.kf.setImage(with: imgUrl4)
                                let imgUrl5 = URL(string: data[4])
                                self.img5.kf.setImage(with: imgUrl5)
                            }
            //

                        }
                        img1.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self)
                            make.bottom.equalTo(self)
                            make.right.equalTo(self.snp.centerX).offset(-2.5)
                        }
                        img2.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.left.equalTo(self.snp.centerX).offset(2.5)
                            make.width.equalTo((self.width - 10)/4)
                            make.height.equalTo((self.height - 5)/2)
                        }
                        img3.snp.makeConstraints { (make) in
                            make.top.equalTo(self)
                            make.right.equalTo(self).offset(0)
                            make.width.equalTo((self.width - 10)/4)
                            make.height.equalTo((self.height - 5)/2)
                        }
                        img4.snp.makeConstraints { (make) in
                            make.bottom.equalTo(self)
                            make.left.equalTo(img2.snp.centerX).offset(2.5)
                            make.width.equalTo((self.width - 10)/4)
                            make.height.equalTo((self.height - 5)/2)
                        }
                        img4.snp.makeConstraints { (make) in
                            make.bottom.equalTo(self)
                            make.right.equalTo(self).offset(0)
                            make.width.equalTo((self.width - 10)/4)
                            make.height.equalTo((self.height - 5)/2)
                }
            
        default:
            DispatchQueue.main.async {
                self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                self.img2.corner(byRoundingCorners: .topRight, radii: 10)
            }
            img1.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.bottom.equalTo(self)
                make.right.equalTo(self.snp.centerX).offset(-2.5)
            }
            img2.snp.makeConstraints { (make) in
                make.top.right.equalTo(self)
                make.bottom.equalTo(img1.snp.centerY).offset(-2.5)
                make.left.equalTo(self.snp.centerX).offset(2.5)
            }
            
            img3.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(self.snp.centerX).offset(2.5)
                make.top.equalTo(img1.snp.centerY).offset(2.5)
                make.right.equalTo(img2.snp.centerX).offset(-2.5)
            }
            img4.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
                make.left.equalTo(img2.snp.centerX).offset(2.5)
                make.top.equalTo(img1.snp.centerY).offset(5)
                make.right.equalTo(self)
            }
        }
    }
    
    func setUI(){
        addSubview(img1)
        addSubview(img2)
        addSubview(img3)
        addSubview(img4)
        addSubview(img5)
        addSubview(img6)

    }
    
        func updateUILocal(_ count:Int,with data:[UIImage]) {
            switch count {
            case 1:
                DispatchQueue.main.async {
                    self.img1.corner(byRoundingCorners: [.topLeft , .topRight], radii: 10)
                        self.img1.image = data[0]
                    
                }
                img1.snp.makeConstraints { (make) in
                    make.top.equalTo(self)
                    make.left.equalTo(self)
                    make.bottom.equalTo(self)
                    make.right.equalTo(self)
                }
            case 2:
                DispatchQueue.main.async {
                    self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                    self.img2.corner(byRoundingCorners: .topRight, radii: 10)
                        self.img1.image =  data[0]
                        self.img2.image = data[1]

                }
                img1.snp.makeConstraints { (make) in
                    make.top.equalTo(self)
                    make.left.equalTo(self)
                    make.bottom.equalTo(self)
                    make.right.equalTo(self.snp.centerX).offset(-2.5)
                }
                img2.snp.makeConstraints { (make) in
                    make.top.right.equalTo(self)
                    make.bottom.equalTo(self)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                }

            case 3:
                DispatchQueue.main.async {
                    self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                    self.img2.corner(byRoundingCorners: .topRight, radii: 10)

                        self.img1.image = data[0]
                        self.img2.image = data[1]
                        self.img3.image = data[2]
                    }
                img1.snp.makeConstraints { (make) in
                    make.top.equalTo(self)
                    make.left.equalTo(self)
                    make.bottom.equalTo(self)
                    make.right.equalTo(self.snp.centerX).offset(-2.5)
                }
                img2.snp.makeConstraints { (make) in
                    make.top.right.equalTo(self)
                    make.bottom.equalTo(img1.snp.centerY).offset(-2.5)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                }
                img3.snp.makeConstraints { (make) in
                    make.bottom.right.equalTo(self)
                    make.top.equalTo(img1.snp.centerY).offset(2.5)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                }
                

            case 4:
                DispatchQueue.main.async {
                    self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                    self.img2.corner(byRoundingCorners: .topRight, radii: 10)
                        self.img1.image = data[0]
                        self.img2.image = data[1]
                        self.img3.image = data[2]
                        self.img4.image = data[3]
                    }
                img1.snp.makeConstraints { (make) in
                    make.top.equalTo(self)
                    make.left.equalTo(self)
                    make.bottom.equalTo(self)
                    make.right.equalTo(self.snp.centerX).offset(-2.5)
                }
                img2.snp.makeConstraints { (make) in
                    make.top.right.equalTo(self)
                    make.bottom.equalTo(img1.snp.centerY).offset(-2.5)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                }
                img3.snp.makeConstraints { (make) in
                    make.bottom.equalTo(self)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                    make.top.equalTo(img1.snp.centerY).offset(2.5)
                    make.right.equalTo(img2.snp.centerX).offset(-2.5)
                }
                img4.snp.makeConstraints { (make) in
                    make.bottom.equalTo(self)
                    make.left.equalTo(img2.snp.centerX).offset(2.5)
                    make.top.equalTo(img1.snp.centerY).offset(5)
                    make.right.equalTo(self)
                }
                
            default:
                DispatchQueue.main.async {
                    self.img1.corner(byRoundingCorners: .topLeft, radii: 10)
                    self.img2.corner(byRoundingCorners: .topRight, radii: 10)
                }
                img1.snp.makeConstraints { (make) in
                    make.top.equalTo(self)
                    make.left.equalTo(self)
                    make.bottom.equalTo(self)
                    make.right.equalTo(self.snp.centerX).offset(-2.5)
                }
                img2.snp.makeConstraints { (make) in
                    make.top.right.equalTo(self)
                    make.bottom.equalTo(img1.snp.centerY).offset(-2.5)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                }
                
                img3.snp.makeConstraints { (make) in
                    make.bottom.equalTo(self)
                    make.left.equalTo(self.snp.centerX).offset(2.5)
                    make.top.equalTo(img1.snp.centerY).offset(2.5)
                    make.right.equalTo(img2.snp.centerX).offset(-2.5)
                }
                img4.snp.makeConstraints { (make) in
                    make.bottom.equalTo(self)
                    make.left.equalTo(img2.snp.centerX).offset(2.5)
                    make.top.equalTo(img1.snp.centerY).offset(5)
                    make.right.equalTo(self)
                }
            }
        }

}
