//
//  ArticleListViewController + CVC.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import Foundation
import UIKit

// MARK: UICollectionView Delegate Methods
extension ArticleListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredArticles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleListCollectionViewCell", for: indexPath) as! ArticleListCollectionViewCell
        cell.configure(with: filteredArticles[indexPath.item], isGrid: isGrid)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = filteredArticles[indexPath.item]
        let vc = ArticleDetailViewController.instantiateFromStoryboard()
        vc.article = article
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: FlowLayout sizing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let insets = layout.sectionInset.left + layout.sectionInset.right
        let spacing = layout.minimumInteritemSpacing

        if isGrid {
            let columns = 2
            let totalSpacing = spacing * CGFloat(columns - 1)
            let width = (collectionView.bounds.width - insets - totalSpacing) / CGFloat(columns)
            return CGSize(width: width, height: 170)
        } else {
            let width = collectionView.bounds.width - insets
            return CGSize(width: width, height: 350)
        }
    }
}
