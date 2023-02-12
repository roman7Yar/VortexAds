//
//  SearchVC.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 10.02.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    let tableView = UITableView()
    var arrOfJokes = [Result]()
    var numberOfRows = 0

    var url = "https://api.chucknorris.io/jokes/search?query="
    
    let searchController = UISearchController()
    
    lazy var jokeManager = JokeManager(urlStr: url)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search joke"
        
        jokeManager.searchCallBack = { (model) -> Void in
            self.didUpdateJokeWithSearch(with: model)
        }
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func didUpdateJokeWithSearch(with model: JokeData) {
        DispatchQueue.main.async {
            self.numberOfRows = model.total
            self.arrOfJokes = model.result
            self.tableView.reloadData()
        }

    }
    
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        var query = ""
        
        text.forEach { char in
            if char == " " {
                query.append("_")
            } else {
                query.append(char)
            }
        }
        
        url = "https://api.chucknorris.io/jokes/search?query=\(query)"
        
        jokeManager.urlStr = url
        jokeManager.fetch(type: .search)
        
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") // TODO: fix showing categories
       
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
                
        let value = arrOfJokes[indexPath.row].value
        let categories = arrOfJokes[indexPath.row].categories
       
        cell?.detailTextLabel?.isEnabled = true
        cell?.textLabel?.text = value
        
        if !categories.isEmpty {
            var category = ""
            
            categories.forEach { str in
                category += str + ", "
            }
            
            category.removeLast(2) // removing ", "

            cell?.detailTextLabel?.text = "category: \(category)"
        } else {
            cell?.detailTextLabel?.text = "category: none"
        }
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let id = arrOfJokes[indexPath.row].id
       
        let url = "https://api.chucknorris.io/jokes/\(id)"
                
        let vc = ChuckNorrisVC()
        
        vc.url = url
        navigationController?.pushViewController(vc, animated: false)
    }
}
