//
//  ArticleDetailViewController.swift
//  Articles
//
//  Created by Sathya on 04/03/26.
//

import UIKit
import Kingfisher
import Loaf

class ArticleDetailViewController: BaseViewController,UIScrollViewDelegate {
    static let name = "ArticleDetailViewController"
    static let storyBoard = "ArticleDetail"
    
    /// The caller of this class does not need to know how we instantiate it.
    /// We simply return the instantiated class to the caller and they invoke it how they want
    /// If the as! fails, it will fail upon immediate testing
    class func instantiateFromStoryboard() -> ArticleDetailViewController {
        let vc = UIStoryboard(name: ArticleDetailViewController.storyBoard, bundle: nil).instantiateViewController(withIdentifier: ArticleDetailViewController.name) as! ArticleDetailViewController
        return vc
    }
    
    @IBOutlet var artcileImageView: UIImageView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
        
    }
    
    func viewLoadSetup() {
        scrollView.delegate = self
        navigationController?.navigationBar.isHidden = true
        if let urlString = article?.urlToImage, let url = URL(string: urlString) {
            artcileImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        } else {
            artcileImageView.image = UIImage(named: "article_placeholder")
        }
        
        titleLable.text = article?.title
        descriptionTextView.text = article?.description
    }
    
    @IBAction func actionOnBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionOnFavLike() {
        Loaf(upcomingSoon, state: .warning, location: .top, sender: self).show(.short)
    }
}
