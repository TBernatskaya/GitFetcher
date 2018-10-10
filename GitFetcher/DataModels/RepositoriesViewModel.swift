//
//  RepositoriesViewModel.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

class RepositoriesViewModel {
    
    var username: String
    var repositories: [Repository]?
    weak var delegate: RepositoriesUpdateListener?
    
    init(with username: String) {
        self.username = username
        fetchRepositories(for: username)
    }
}

extension RepositoriesViewModel: ApiService {
    
    func fetchRepositories(for searchText: String) {
        
        repositories(for: searchText, completion: { [weak self] (repositories, error) in
            guard let weakSelf = self else { return }
            
            if let repositories = repositories {
                weakSelf.repositories = repositories
                weakSelf.delegate?.didUpdateRepositories()
            }
            else if let error = error {
                weakSelf.delegate?.didReceive(error: error)
            }
        })
    }
}
