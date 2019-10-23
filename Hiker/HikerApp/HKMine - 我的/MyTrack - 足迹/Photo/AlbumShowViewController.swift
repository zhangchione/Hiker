//
//  AlbumShowViewController.swift
//  Show
//
//  Created by nine on 2018/9/1.
//

import UIKit
import SnapKit

import Hero
import Photos

import CollectionKit
import ACBadge

//protocol AlbumShowDelegate: class {
//    func reloadPhoto()
//}

class AlbumShowViewController: UIViewController {
    var panGR = UIPanGestureRecognizer()
    //    weak var delegate: AlbumShowDelegate?
    var photos: [Photo]
    // MARK: UI
    var titleView = UIView()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "PingFangSC-Regular", size: 18)
        label.textAlignment = .center
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        label.textAlignment = .center
        return label
    }()
    var backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "nav_item_back"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchDown)
        return btn
    }()
    var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "nav_item_delete"), for: .normal)
        btn.addTarget(self, action: #selector(showDelectVC), for: .touchDown)
        return btn
    }()
    var localStatuDot: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "show_ico_dot")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(rgb: 0xCCD3D3)
        return iv
    }()
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = space
        return layout
    }()
    lazy var pageCollectionView: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.isPagingEnabled = true
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    var bottomCollectionView: CollectionView = {
        let cv = CollectionView()
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    var currentSelectedCategorys = [String]()
    var bottomDataSource = ArrayDataSource(data: DataSingle.shared.myAlbums.map { $0.key }.filter { AlbumHelper.isAppAlbum($0) })
    var space: CGFloat = 42.0.fit * 2.0 // 左右
    lazy var cellSize: CGSize = CGSize(width: pageCollectionView.size.width - space,
                                       height: pageCollectionView.size.height)
    var initialIndex: Int
    lazy var pageMoveWidth: CGFloat = view.frame.width
    lazy var pageMoveHeight: CGFloat = cellSize.height
    // temp
    var cellOriginCenterY: CGFloat = 0
    var currentPage: Int {
        didSet {
            let photo = photos[currentPage]
            setTitle(with: photo.asset)
            setSelected(with: photo)
        }
    }

    init(to index: Int, with photos: [Photo]) {
        currentPage = index
        initialIndex = index
        self.photos = photos
        super.init(nibName: nil, bundle: nil)
        bottomCollectionView.hero.modifiers = [.translate(y: 200)]
        hero.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configGesture()
        configTitle()
        configUI()
        configClassifyCollectionView()
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        jump(to: initialIndex)
        DispatchQueue.main.async { self.currentPage = self.initialIndex }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDelectButton(DataSingle.shared.delectPhots.value.count)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pan() {
        let translation = panGR.translation(in: nil)
//        let progressX =  translation.x / 2 / self.view.frame.width
        let progressY =  translation.y / 2 / self.view.frame.height
//        _ = progressY > progressX ? progressY : progressX
        guard (pageCollectionView.cellForItem(at: IndexPath.init(item: currentPage, section: 0)) as? AlbumShowCell) != nil else {return}
        if progressY < 0, pageCollectionView.point(inside: panGR.location(in: pageCollectionView), with: nil) {
            Hero.shared.cancel()
            move(with: progressY)
        } else {
            dissMiss(with: progressY)
        }
    }

    @objc func deletePhoto() {
        NoticeHelper.shake(style: .medium)
        let photo = photos[currentPage]

        if PhotoDataManager.isDelected(with: photo) {
            PhotoDataManager.removeDelect(photos: [photo])
            jump(to: currentPage)
        } else {
            PhotoDataManager.addDelect(photos: [photo])
            jump(to: currentPage+1)
        }
    }

    func updateDelectButton(_ number: Int) {
        deleteBtn.ac_showBadge(with: .redDot)
        if number == 0 {
            deleteBtn.ac_clearBadge() // 清除红点
        } else {
            deleteBtn.ac_showBadge(with: .number(with: number)) // number传0时消失
        }
    }

    func configUI() {
        view.addSubview(pageCollectionView)
        view.addSubview(bottomCollectionView)
        bottomCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).inset(UIScreen().safeAreaInsets.bottom/3)
            make.height.equalTo(121.fit)
        }
        pageCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(11.fit)
            make.bottom.equalTo(bottomCollectionView.snp.top).offset(-22.fit)
            make.left.right.equalTo(view)
        }
        view.layoutIfNeeded()
        pageCollectionView.register(AlbumShowCell.self, forCellWithReuseIdentifier: "AlbumShowCell")
    }

    func configTitle() {
        view.addSubview(titleView)
        titleView.addSubview(backBtn)
        titleView.addSubview(titleLabel)
        titleView.addSubview(deleteBtn)
        titleView.addSubview(timeLabel)
        titleView.addSubview(localStatuDot)
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(view).inset(UIScreen().titleY)
            make.left.right.equalTo(view)
            make.height.equalTo(44)
        }
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(titleView).inset(22)
            make.top.equalTo(titleView).inset(13)
            make.height.width.equalTo(18)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView)
            make.top.equalTo(titleView).inset(5)
            make.width.equalTo(160)
            make.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalTo(160)
            make.height.equalTo(19)
        }
        localStatuDot.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left)
            make.width.height.equalTo(19)
            make.centerY.equalTo(timeLabel)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(titleView).inset(22)
            make.top.equalTo(titleView).inset(13)
            make.height.equalTo(24)
            make.width.equalTo(22)
        }
    }
}

// MARK: - Action
extension AlbumShowViewController {

    private func move(with progressY: CGFloat) {
        guard let cell = pageCollectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? AlbumShowCell else {return}
        if cellOriginCenterY == 0 { cellOriginCenterY = cell.imageView.centerY }
        let ratio: CGFloat = 4.0 // 上滑速度比例
        switch panGR.state {
        case .began:
            break
        case .changed:
            if cellOriginCenterY == 0 { break }
            cell.imageView.centerY = cellOriginCenterY * (1+progressY*ratio)
        case .cancelled, .ended:
            if progressY < -0.10 {
                let temp = self.cellOriginCenterY
                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                    cell.imageView.centerY = -300
                }) { (_) in
                    cell.imageView.centerY = temp
                }
                deletePhoto()
            } else {
                if cellOriginCenterY == 0 { break }
                UIView.animate(withDuration: 0.15) {
                    cell.imageView.centerY = self.cellOriginCenterY
                }
            }
        default:
            break
        }
    }

    func dissMiss(with progressY: CGFloat) {
        switch panGR.state {
        case .began:
            hero.dismissViewController()
            if let cell = pageCollectionView.cellForItem(at: IndexPath.init(item: currentPage, section: 0)) as? AlbumShowCell {
                let photo = photos[currentPage]
                cell.imageView.hero.id = "albumCellImage_\(photo.asset.localIdentifier)"
            }
        case .changed:
            Hero.shared.update(progressY)
        default:
            let ratio = progressY + panGR.velocity(in: nil).y / self.view.frame.height
            if ratio > 0.10 {
                //                delegate?.reloadPhoto()
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }

    @objc func back() {
        //        self.delegate?.reloadPhoto()
        dismiss(animated: true, completion: nil)
        if let cell = pageCollectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? AlbumShowCell {
            cell.imageView.hero.id = "albumCellImage_\(currentPage)"
        }
    }

    @objc func showDelectVC() {
//        let vc = DelectAlbumViewController()
//        vc.hero.isEnabled = true
//        vc.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
//        present(vc, animated: true, completion: nil)
    }

}
// MARK: Tool
extension AlbumShowViewController {

    func jump(to index: Int) {
        if index >= photos.count { return }
        pageCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        currentPage = index
    }

    func setSelected(with photo: Photo) {
        DispatchQueue.global().async {
            self.currentSelectedCategorys = self.findMyAlbumCategorys(with: photo)
            DispatchQueue.main.async {
                self.updateTitleDot(isLocal: !self.currentSelectedCategorys.isEmpty)
                self.updateTitleDot(isDelect: DataSingle.shared.delectPhots.value.first(where: {p in p==photo}) != nil)
                self.bottomCollectionView.reloadData()
            }
        }
    }
    // 该照片所在的所有分类
    func findMyAlbumCategorys(with: Photo) -> [String] {
        let thingCategorys = DataSingle.shared.myAlbums.map { $0.key }.filter { AlbumHelper.isAppAlbum($0) }
        var res = [String]()
        for category in thingCategorys {
            let hadPhoto = DataSingle.shared.myAlbums[category]?.photos.contains(where: { p in
                p.asset == photos[currentPage].asset
            })
            if let had = hadPhoto, had { res.append(category) }
        }
        return res
    }
}
