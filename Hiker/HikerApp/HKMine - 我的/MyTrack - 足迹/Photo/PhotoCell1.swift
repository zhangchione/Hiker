//
//  PhotoCell.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import SwifterSwift

protocol PhotoCell1Delegate: class {
    func canSelected() -> Bool
}
class PhotoCell1: UICollectionViewCell {
    weak var delegate: PhotoCell1Delegate?
    /// 被选遮罩
    var selectedCover: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = Color(hexString: "#2ADAD5")
        iv.alpha = 0.2
        iv.isHidden = true
        return iv
    }()
    var selectedIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "photos_cell_selected")
        iv.isHidden = true
        return iv
    }()
    var imageView = UIImageView()
    override var isSelected: Bool {
        didSet {
            guard let d = delegate, d.canSelected() else { return }
            selectedCover.isHidden = !isSelected
            selectedIcon.isHidden = !isSelected
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    private func configUI() {
        addSubview(imageView)
        addSubview(selectedCover)
        addSubview(selectedIcon)
        layer.cornerRadius = 5
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = contentView.frame
        selectedCover.frame = imageView.frame
        selectedIcon.frame = CGRect(x: contentView.frame.width-33.fit, y: contentView.frame.height-33.fit, width: 24.fit, height: 24.fit)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
