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
                weakSelf.repositories = repositories.map{ item -> (Repository) in
                    item.isStarred = weakSelf.starStatus(for: item.id)
                    return item
                }
                weakSelf.delegate?.didUpdateRepositories()
                
            } else if let error = error {
                weakSelf.delegate?.didReceive(error: error)
            }
        })
    }
    
    func star(repository: Repository, completion: @escaping (Error?) -> ()) {
        star(repository: repository.name, owner: repository.owner.login, completion: { [weak self] error in
            guard let weakSelf = self else { return }
            
            if let error = error {
                weakSelf.delegate?.didReceive(error: error)
                completion(error)
            } else {
                repository.isStarred = true
                weakSelf.starredRepositories?.add(item: repository)
                weakSelf.delegate?.didUpdateRepositories()
                completion(nil)
            }
        })
    }
    
    func unstar(repository: Repository, completion: @escaping (Error?) -> ()) {
        unstar(repository: repository.name, owner: repository.owner.login, completion: { [weak self] error in
            guard let weakSelf = self else { return }
            
            if let error = error {
                weakSelf.delegate?.didReceive(error: error)
                completion(error)
            } else {
                repository.isStarred = false
                weakSelf.starredRepositories?.remove(repositoryID: repository.id)
                weakSelf.delegate?.didUpdateRepositories()
                completion(nil)
            }
        })
    }
}

fileprivate extension RepositoriesViewModel {
    func starStatus(for repositoryID: Int) -> Bool {
        guard let starredRepositories = starredRepositories else { return false }
        return starredRepositories.repositoryIDs.contains{ $0 == repositoryID }
    }
}
