//
//  SplashViewController.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import UIKit
import FTLinearActivityIndicator

class SplashViewController: UIViewController {
    static let name = "SplashViewController"
    static let storyBoard = "Main"
    
    /// The caller of this class does not need to know how we instantiate it.
    /// We simply return the instantiated class to the caller and they invoke it how they want
    /// If the as! fails, it will fail upon immediate testing
    class func instantiateFromStoryboard() -> SplashViewController {
        let vc = UIStoryboard(name: SplashViewController.storyBoard, bundle: nil).instantiateViewController(withIdentifier: SplashViewController.name) as! SplashViewController
        return vc
    }
    
    @IBOutlet weak var activityIndicatorView: FTLinearActivityIndicator!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.initalDashboad()
        }
    }

    func initalDashboad() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        
        let articleVC = ArticleListViewController.instantiateFromStoryboard()
        
        let customNav = CustomNavigationController(rootViewController: articleVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            window.rootViewController = customNav
            window.makeKeyAndVisible()
            
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
}

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = .white
        navigationBar.prefersLargeTitles = true
    }
}
