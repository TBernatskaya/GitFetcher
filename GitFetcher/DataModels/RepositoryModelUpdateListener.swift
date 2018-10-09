//
//  RepositoryModelUpdateListener.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

protocol RepositoryModelUpdateListener: class {
    func didUpdateStarStatus(to isStarred: Bool)
}
