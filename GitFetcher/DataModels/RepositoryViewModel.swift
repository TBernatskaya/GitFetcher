//
//  RepositoryViewModel.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

struct RepositoryViewModel {
    
    var repository: Repository
    
    init(with repository: Repository) {
        self.repository = repository
    }
}

extension RepositoryViewModel: UpdateListener {}
