//
//  MainViewController.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var repositoriesList: [Repository]? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        
        registerClasses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
}

fileprivate extension MainViewController {
    
    func updateView() {
        
        guard
            let repositoriesList = self.repositoriesList,
            repositoriesList.count > 0
        else {
            return showTextMessage()
        }
        showSearchResults()
    }
    
    func showSearchResults() {
        errorLabel.isHidden = true
        searchResultsTableView.isHidden = false
        searchResultsTableView.reloadData()
    }
    
    func showTextMessage() {
        searchResultsTableView.isHidden = true
        errorLabel.isHidden = false
    }
    
    func clearView() {
        repositoriesList?.removeAll()
    }
    
    func registerClasses() {
        let cellReuseIdentifier = "searchResultCell"
        let cellNib = UINib.init(nibName: "SearchResultTableViewCell", bundle: Bundle.main)
        searchResultsTableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        ApiService().repositories(for: searchText, completion: { repositories, error in
            if let repositories = repositories {
                self.repositoriesList = repositories
            } else if let error = error {
                self.searchResultsTableView.isHidden = true
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.isHidden = false
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            clearView()
        }
    }
    
    func searchBarCancelButtonClicked(_ seachBar: UISearchBar) {
        clearView()
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultTableViewCell
        
        guard let repositoriesList = self.repositoriesList else { return cell }
        cell.nameLabel.text = repositoriesList[indexPath.row].name
        cell.descriptionLabel.text = repositoriesList[indexPath.row].description
        cell.urlLabel.text = repositoriesList[indexPath.row].url.absoluteString
        
        return cell
    }
}
