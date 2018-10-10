//
//  MainViewController+UISearchBarDelegate.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        repositoriesViewModel = RepositoriesViewModel.init(with: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            clearView()
        }
    }
    
    func searchBarCancelButtonClicked(_ seachBar: UISearchBar) {
        searchBar.resignFirstResponder()
        clearView()
    }
}
