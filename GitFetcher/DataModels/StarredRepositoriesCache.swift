//
//  StarredRepositoriesCache.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-10.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

class StarredRepositoriesCache: ApiService {
    var repositoryIDs: [Int] = []
    
    func fetchStarredRepositories() {
        starList(completion: { [weak self] (repositories, error) in
            guard let weakSelf = self else { return }
            
            if let repositories = repositories {
                weakSelf.repositoryIDs = repositories.compactMap{ $0.id}
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func add(item: Repository) {
        repositoryIDs.append(item.id)
    }
    
    func remove(repositoryID: Int) {
        repositoryIDs.removeAll(where: { $0 == repositoryID })
    }
}
