//
//  ViewController.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 01.02.2023.
//

import UIKit

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

