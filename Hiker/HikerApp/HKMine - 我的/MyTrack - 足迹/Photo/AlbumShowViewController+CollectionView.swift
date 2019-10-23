//
//  AlbumShowViewController+CollectionView.swift
//  VCFactory
//
//  Created by nine on 2018/9/26.
//

import Foundation
import UIKit

extension AlbumShowViewController: UICollectionViewDelegate {

}
extension AlbumShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: space/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
extension AlbumShowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        guard let d = self.delegate else { return 0 }
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumShowCell", for: indexPath) as? AlbumShowCell) else { return UICollectionViewCell() }
        let photo = photos[indexPath.item]
        imageCell.configUI(with: photo.asset)
        imageCell.setUI(with: photo.asset)
        if indexPath.item == initialIndex {
            imageCell.imageView.hero.id = "albumCellImage_\(photo.asset.localIdentifier)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                imageCell.imageView.hero.id = nil
            })
        }
        return imageCell
    }
}
extension AlbumShowViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Destination x
        let x = targetContentOffset.pointee.x
        // Page width equals to cell width
        let pageWidth = pageMoveWidth
        // Check which way to move
        let movedX = x - pageWidth * CGFloat(currentPage)
        if movedX < -pageWidth * 0.5 {
            // Move left
            currentPage -= 1
        } else if movedX > pageWidth * 0.5 {
            // Move right
            currentPage += 1
        }

        //        if abs(velocity.x) >= 2 {
        //            targetContentOffset.pointee.x = pageWidth * CGFloat(currentPage)
        //        } else {
        //            // If velocity is too slow, stop and move with default velocity
        //            targetContentOffset.pointee.x = scrollView.contentOffset.x
        //            scrollView.setContentOffset(CGPoint(x: pageWidth * CGFloat(currentPage), y: scrollView.contentOffset.y), animated: true)
        //        }
    }
}
