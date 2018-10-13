//
//  StarredRepositoriesCache.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-10.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

class StarredRepositoriesCache: ApiService {
    var repositories: [Repository] = []
    
    func fetchStarredRepositories() {
        starList(completion: { [weak self] (repositories, error) in
            guard let weakSelf = self else { return }
            
            if let repositories = repositories {
                weakSelf.repositories = repositories
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func add(item: Repository) {
        repositories.append(item)
    }
    
    func remove(repositoryID: Int) {
        repositories.removeAll(where: {$0.id == repositoryID} )
    }
}
