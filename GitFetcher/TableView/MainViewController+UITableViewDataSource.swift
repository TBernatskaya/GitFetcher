//
//  MainViewController+UITableViewDataSource.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesViewModel?.repositories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultTableViewCell
        
        guard let cellViewModel = cellViewModel(by: indexPath) else { return cell }
        cell.nameLabel.text = cellViewModel.name
        cell.descriptionLabel.text = cellViewModel.description
        cell.urlLabel.text = cellViewModel.url.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailViewController.repositoryViewModel = cellViewModel(by: indexPath)
        presentDetails()
    }
    
    fileprivate func cellViewModel(by indexPath: IndexPath) -> Repository? {
        guard let repositoriesList = repositoriesViewModel?.repositories else { return nil }
        
        return repositoriesList[indexPath.row]
    }
}
