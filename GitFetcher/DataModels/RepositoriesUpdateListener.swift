//
//  RepositoriesUpdateListener.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

protocol RepositoriesUpdateListener: class {
    func didUpdateRepositories()
    func didReceive(error: Error)
    func didUpdateStarStatus(to isStarred: Bool)
}
