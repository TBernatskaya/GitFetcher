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
        return repositoriesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultTableViewCell
        
        guard let viewModel = viewModel(by: indexPath) else { return cell }
        cell.nameLabel.text = viewModel.repository.name
        cell.descriptionLabel.text = viewModel.repository.description
        cell.urlLabel.text = viewModel.repository.url.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailViewController.repositoryViewModel = viewModel(by: indexPath)
        presentDetails()
    }
    
    fileprivate func viewModel(by indexPath: IndexPath) -> RepositoryViewModel? {
        guard let repositoriesList = self.repositoriesList else { return nil }
        
        return repositoriesList[indexPath.row]
    }
}
