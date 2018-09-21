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
        
        guard let repositoriesList = self.repositoriesList else { return cell }
        cell.nameLabel.text = repositoriesList[indexPath.row].name
        cell.descriptionLabel.text = repositoriesList[indexPath.row].description
        cell.urlLabel.text = repositoriesList[indexPath.row].url.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repositoriesList = self.repositoriesList else { return }
        let url = repositoriesList[indexPath.row].url
        openSafari(with: url)
    }
}
