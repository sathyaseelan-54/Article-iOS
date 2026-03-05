//
//  ArticleListCollectionViewCell.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//
import Foundation
import UIKit
import Kingfisher

class ArticleListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var articlePosterImage: UIImageView!
    @IBOutlet weak var publishedAtLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var readmoreButton: UIButton!
    
    @IBOutlet weak var bottomViewNSConst: NSLayoutConstraint!
    @IBOutlet weak var articlePosterImageNSConst: NSLayoutConstraint!
    

    override func prepareForReuse() {
        super.prepareForReuse()
        articlePosterImage.kf.cancelDownloadTask()
        articlePosterImage.setCornerRadius(radius: 8)
        articlePosterImage.image = nil
        mainView.setCornerRadius(radius: 8)
        readmoreButton.setCornerRadius(radius: 8)
        descriptionLable.isHidden = false
    }

    func configure(with article: Article, isGrid: Bool) {
        descriptionLable.text = article.content
        publishedAtLable.text = String.formatPublishedAtString(article.publishedAt ?? emptyString)
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            articlePosterImage.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        } else {
            articlePosterImage.image = UIImage(named: "article_placeholder")
        }

        bottomView.isHidden = isGrid
        bottomViewNSConst.constant = isGrid ? 0 : 50
        articlePosterImageNSConst.constant = isGrid ? 85 : 194
    }
}
