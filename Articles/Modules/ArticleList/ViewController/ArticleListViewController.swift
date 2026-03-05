//
//  ArticleListViewController.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import UIKit
import Loaf
import FTLinearActivityIndicator
import Foundation
import AlamofireNetworkActivityIndicator

class ArticleListViewController: BaseViewController {
    static let name = "ArticleListViewController"
    static let storyBoard = "ArticleList"
    
    /// The caller of this class does not need to know how we instantiate it.
    /// We simply return the instantiated class to the caller and they invoke it how they want
    /// If the as! fails, it will fail upon immediate testing
    class func instantiateFromStoryboard() -> ArticleListViewController {
        let vc = UIStoryboard(name: ArticleListViewController.storyBoard, bundle: nil).instantiateViewController(withIdentifier: ArticleListViewController.name) as! ArticleListViewController
        return vc
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyDataView: UIView!
    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarNSLConst: NSLayoutConstraint!
    
    var articles: [Article] = []
    var filteredArticles: [Article] = []
    
    var isGrid = false
    var isSearching = false
    
    private let spinner = UIActivityIndicatorView(style: .large)

    let activityIndicator = FTLinearActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = articelsTitle
        setupSpinner()
//        setupLiquidGlassBackground()
        setupCollectionView()
        setupNavItems()
        registerCollectionViewCells()
        setupSearchBar()
        retryView.setCornerRadius(radius: 12,borderColor: .secondary,borderWidth: 2)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        fetchArticles()
    }
    
    private func setupSpinner() {
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    

    /// Register CollectionView Cell
    func registerCollectionViewCells() {
        let nibCell = UINib(nibName: "ArticleListCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ArticleListCollectionViewCell")
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = searchArticlePlaceholder
        searchBar.isHidden = true
        searchBar.alpha = 0
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            layout.estimatedItemSize = .zero // we’ll size manually for consistency across modes
        }
    }

    func setupNavItems() {
        let gird = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(toggleLayout))
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(searchTapped))
        navigationItem.setRightBarButtonItems([search,gird], animated: true)
    }

    func observeConnectivity() {
        ReachabilityService.shared.start { [weak self] reachable in
            guard let self else { return }
            DispatchQueue.main.async {
                if reachable {
                    self.emptyDataView.isHidden = true
                    Loaf(backToOnline, state: .success, location: .top, sender: self).show(.short)
                    self.fetchArticles()
                } else {
                    self.emptyDataView.isHidden = false
                    Loaf(youAreOffline, state: .warning, location: .top, sender: self).show(.short)
                }
            }
        }
    }

    func fetchArticles() {
        setLoading(true)
        spinner.startAnimating()
        observeConnectivity()
        NetworkManager.shared.request(router: .getArticle, responseType: ArticleResponse.self) { [weak self] response in
            DispatchQueue.main.async {
                self?.setLoading(false)
                self?.spinner.stopAnimating()
                switch response {
                case .success(let result):
                    self?.articles = result.articles
                    self?.filteredArticles = result.articles
                    self?.emptyDataView.isHidden = self?.articles.count ?? 0 > 0
                    self?.collectionView.reloadData()
                case .failure(let error):
                    guard let self = self else { return }
                    self.emptyDataView.isHidden = false
                    Loaf("Failed to load: \(error.localizedDescription)", state: .error, sender: self).show()
                }
            }
        }
    }

    private func setLoading(_ loading: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.activityIndicator.alpha = loading ? 1 : 0
        }
    }

    @objc private func toggleLayout() {
        isGrid.toggle()
        
        navigationItem.rightBarButtonItems?[1].image = UIImage(
            systemName: isGrid ? "square.grid.2x2" : "list.bullet"
        )
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            UIView.animate(withDuration: 0.25) {
                layout.invalidateLayout()
                self.collectionView.layoutIfNeeded()
            }
        }
        collectionView.reloadData()
    }
    
    func filterArticles(with query: String) {
        if query.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter {
                $0.title?.lowercased().contains(query.lowercased()) ?? false
            }
        }
        emptyDataView.isHidden = !filteredArticles.isEmpty
        collectionView.reloadData()
    }
    
    @objc private func searchTapped() {
        isSearching.toggle()
        searchBarNSLConst.constant = isSearching ? 50 : 0
        UIView.animate(withDuration: 0.25) {
            self.searchBar.isHidden = !self.isSearching
            self.searchBar.alpha    = self.isSearching ? 1 : 0
        }
        
        if isSearching {
            searchBar.becomeFirstResponder()
        } else {
            searchBar.text = emptyString
            searchBar.resignFirstResponder()
            filteredArticles = articles 
            collectionView.reloadData()
        }
    }
    
    @IBAction func actionOnRetry() {
        fetchArticles()
    }
    
    func setupLiquidGlassBackground() {
        // Rich dark gradient so glass cells look vivid
        let gradient = CAGradientLayer()
        gradient.colors   = [
            UIColor(red: 0.07, green: 0.09, blue: 0.14, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.13, blue: 0.20, alpha: 1).cgColor,
            UIColor(red: 0.13, green: 0.24, blue: 0.27, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame  = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        // CollectionView must be transparent so gradient shows through glass cells
        collectionView.backgroundColor = .clear
    }
}

extension ArticleListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterArticles(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = emptyString
        filteredArticles = articles
        isSearching = false
        UIView.animate(withDuration: 0.2) {
            self.searchBar.isHidden = true
            self.searchBar.alpha    = 0
        }
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
}
