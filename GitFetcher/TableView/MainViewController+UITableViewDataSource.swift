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
        guard
            let viewModel = repositoriesViewModel,
            let repositories = viewModel.repositories
        else { return 0 }
        
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultTableViewCell
        guard let cellViewModel = cellViewModel(by: indexPath) else { return cell }
        
        cell.nameLabel.text = cellViewModel.name
        cell.descriptionLabel.text = cellViewModel.description
        cell.urlLabel.text = cellViewModel.url.absoluteString
        cell.starStatusLabel.text = cellViewModel.isStarred ? "Starred" : "Is not starred"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repository = cellViewModel(by: indexPath) else { return }
        presentDetails(for: repository)
    }
    
    fileprivate func cellViewModel(by indexPath: IndexPath) -> Repository? {
        guard let repositoriesList = repositoriesViewModel?.repositories else { return nil }
        return repositoriesList[indexPath.row]
    }
}
