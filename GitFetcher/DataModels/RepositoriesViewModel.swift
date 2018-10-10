//
//  RepositoriesViewModel.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

class RepositoriesViewModel {
    
    var repositories: [Repository]
    var starredRepositories: [Repository] = []
    
    weak var delegate: RepositoriesUpdateListener?
    
    init(with repositories: [Repository]) {
        self.repositories = repositories
    }
}

extension RepositoriesViewModel: ApiService {}
