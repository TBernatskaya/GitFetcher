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
    var starredRepositories: StarredRepositoriesCache?
    weak var delegate: RepositoriesUpdateListener?
    
    init(with username: String, starredRepositories: StarredRepositoriesCache) {
        self.username = username
        self.starredRepositories = starredRepositories
        
        fetchRepositories(for: username)
    }
}

extension RepositoriesViewModel: ApiService {
    
    func fetchRepositories(for searchText: String) {
        
        repositories(for: searchText, completion: { [weak self] (repositories, error) in
            guard let weakSelf = self else { return }
            
            if let repositories = repositories {
                let data = repositories.map{ item -> (Repository) in
                    var newItem = item
                    newItem.isStarred = weakSelf.starStatus(for: newItem)
                    return newItem
                }
                
                weakSelf.repositories = data
                weakSelf.delegate?.didUpdateRepositories()
                
            } else if let error = error {
                weakSelf.delegate?.didReceive(error: error)
            }
        })
    }
}

fileprivate extension RepositoriesViewModel {
    func starStatus(for repository: Repository) -> Bool {
        guard let starredRepositories = starredRepositories else { return false }
        return starredRepositories.repositories.contains{ $0.id == repository.id }
    }
}
