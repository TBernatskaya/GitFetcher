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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
}

extension MainViewController: UISearchBarDelegate {
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        
        return cell!
    }
}
