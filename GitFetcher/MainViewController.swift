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
    
    func clearView() {
        repositoriesList?.removeAll()
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
    
    func registerClasses() {
        let cellReuseIdentifier = "searchResultCell"
        let cellNib = UINib.init(nibName: "SearchResultTableViewCell", bundle: Bundle.main)
        searchResultsTableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
    }
}
