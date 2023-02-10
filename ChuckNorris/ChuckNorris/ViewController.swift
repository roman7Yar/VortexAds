//
//  ViewController.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 01.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        return button
    }() // TODO: replace with Category and Random
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.center = view.center
    }
    
    @objc func didTapButton() {
        let tabBarVC = UITabBarController()
        
        let categoryVC = UINavigationController(rootViewController: CategoriesVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let savedVC = UINavigationController(rootViewController: SavedVC())
        
        categoryVC.title = "Categories"
        searchVC.title = "Search"
        savedVC.title = "Saved"
        
        tabBarVC.setViewControllers([categoryVC, searchVC, savedVC], animated: false)
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        let images = ["line.horizontal.3", "magnifyingglass", "bookmark.fill"]
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
        
    }
    
}

