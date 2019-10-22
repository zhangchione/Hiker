//
//  PageCollectionView.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

import SnapKit
class PageCollectionView: UICollectionView {
}

// MARK: init

extension PageCollectionView {

    class func createOnView(_ view: UIView,
                            layout: UICollectionViewLayout,
                            height: CGFloat,
                            dataSource: UICollectionViewDataSource,
                            delegate: UICollectionViewDelegate) -> PageCollectionView {

        let collectionView = Init(PageCollectionView(frame: CGRect.zero, collectionViewLayout: layout)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = UIColor(white: 0, alpha: 0)
        }
        view.addSubview(collectionView)
        //collectionView.frame = CGRect(x: 0, y: 250, width: 414, height: 550)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(22)
            make.height.equalTo(644)
        }
        collectionView.backgroundColor = .red
       
//        // add constraints
//        collectionView >>>- {
//            $0.attribute = .height
//            $0.constant = height
//            return
//        }
//        [NSLayoutConstraint.Attribute.left, .right, .bottom].forEach { attribute in
//            (view, collectionView) >>>- {
//                $0.attribute = attribute
//                print(attribute.rawValue)
//                return
//            }
//        }

        return collectionView
    }
}

class PageCollectionView1: UICollectionView {
}

// MARK: init

extension PageCollectionView1 {

    class func createOnView(_ view: UIView,
                            layout: UICollectionViewLayout,
                            height: CGFloat,
                            dataSource: UICollectionViewDataSource,
                            delegate: UICollectionViewDelegate) -> PageCollectionView1 {

        let collectionView = Init(PageCollectionView1(frame: CGRect.zero, collectionViewLayout: layout)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.backgroundColor = UIColor(white: 0, alpha: 0)
        }
        view.addSubview(collectionView)
        //collectionView.frame = CGRect(x: 0, y: 250, width: 414, height: 550)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(35)
            make.height.equalTo(644)
        }
       // collectionView.backgroundColor = .red
//        // add constraints
//        collectionView >>>- {
//            $0.attribute = .height
//            $0.constant = height
//            return
//        }
//        [NSLayoutConstraint.Attribute.left, .right, .bottom].forEach { attribute in
//            (view, collectionView) >>>- {
//                $0.attribute = attribute
//                print(attribute.rawValue)
//                return
//            }
//        }

        return collectionView
    }
}
