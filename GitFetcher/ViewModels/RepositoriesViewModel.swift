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

extension RepositoriesViewModel: ApiService, RepositoriesUpdater {
    
    func fetchRepositories(for searchText: String) {
        
        repositories(for: searchText, completion: { [weak self] (repositories, error) in
            guard let weakSelf = self else { return }
            
            if let repositories = repositories {
                let data = repositories.map{ item -> (Repository) in
                    var newItem = item
                    newItem.isStarred = weakSelf.starStatus(for: newItem.id)
                    return newItem
                }
                
                weakSelf.repositories = data
                weakSelf.delegate?.didUpdateRepositories()
                
            } else if let error = error {
                weakSelf.delegate?.didReceive(error: error)
            }
        })
    }
    
    func star(repository: Repository) {
        star(repository: repository.name, owner: repository.owner.login, completion: { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            
            if success {
                weakSelf.starredRepositories?.add(item: repository)
                
                if let repositories = weakSelf.repositories {
                    let data = repositories.map{ item -> (Repository) in
                        var newItem = item
                        
                        if (item.id == repository.id) {
                            newItem.isStarred = true
                        }
                        return newItem
                    }
                    weakSelf.repositories = data
                    weakSelf.delegate?.didUpdateRepositories()
                }
            }
            
            if let error = error {
                weakSelf.delegate?.didReceive(error: error)
            }
        })
    }
    
    func unstar(repository: Repository) {
        unstar(repository: repository.name, owner: repository.owner.login, completion: { [weak self] (success, error) in
            guard let weakSelf = self else { return }
            
            if success {
                weakSelf.starredRepositories?.remove(repositoryID: repository.id)
                
                if let repositories = weakSelf.repositories {
                    let data = repositories.map{ item -> (Repository) in
                        var newItem = item
                        
                        if (item.id == repository.id) {
                            newItem.isStarred = false
                        }
                        return newItem
                    }
                    weakSelf.repositories = data
                    weakSelf.delegate?.didUpdateRepositories()
                }
            }
            
            if let error = error {
                weakSelf.delegate?.didReceive(error: error)
            }
        })
    }
}

fileprivate extension RepositoriesViewModel {
    func starStatus(for repositoryID: Int) -> Bool {
        guard let starredRepositories = starredRepositories else { return false }
        return starredRepositories.repositories.contains{ $0.id == repositoryID }
    }
}
