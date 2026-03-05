//
//  BaseViewController.swift
//  Articles
//
//  Created by Sathya on 04/03/26.
//

import UIKit

class BaseViewController: UIViewController {

    override var title : String? {
        didSet {
            navigationItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    func setup() {
        // Turn off large titles if you don’t want the big collapsing header
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle) 
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left

        // Container to force leading alignment inside titleView
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(greaterThanOrEqualTo: titleLabel.widthAnchor),
            container.heightAnchor.constraint(greaterThanOrEqualTo: titleLabel.heightAnchor)
        ])

        navigationItem.titleView = container
    }

}
