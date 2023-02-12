//
//  SavedVC.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 10.02.2023.
//

import UIKit

class SavedVC: UIViewController {
    
    let image = UIImage(systemName: "arrow.triangle.2.circlepath")
    let tableView = UITableView()
    var arrOfJokes = [Result]()
    var numberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Saved"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(reloadTapped))
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self 
        tableView.dataSource = self

        getSavedData()
        
        tableView.reloadData()
    }
    
    @objc func reloadTapped() {
        getSavedData()
        tableView.reloadData()
    }
  
    func getSavedData() {
        
        let data = UserDefaultsManager.shared.getData()!
       
        arrOfJokes = data
        numberOfRows = data.count
    }
    
}

extension SavedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") // TODO: fix showing categories
       
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        
        let value = arrOfJokes[indexPath.row].value
        let categories = arrOfJokes[indexPath.row].categories
       
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
        
        let data = arrOfJokes[indexPath.row]
                
        let vc = ChuckNorrisVC()
        vc.data = data
        vc.bool = true
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

