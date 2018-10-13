//
//  RepositoriesUpdater.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-13.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

protocol RepositoriesUpdater: class {
    func star(repository: Repository)
    func unstar(repository: Repository)
}
