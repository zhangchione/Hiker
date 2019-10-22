//
//  NotesCell.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/24.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit

class NotesCell: BasePageCollectionCell {
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var tag1: UIButton!
    @IBOutlet weak var tag2: UIButton!
    @IBOutlet weak var tag3: UIButton!
    
    lazy var photoCell:PhotoCell = {
        let photoCell = PhotoCell()
        return photoCell
    }()
    
    @IBOutlet weak var photoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoView.addSubview(photoCell)
        photoCell.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(photoView)
        }
        //photoCell.imgDatas = ["img1","img2","img3","img3"]
    }

}
