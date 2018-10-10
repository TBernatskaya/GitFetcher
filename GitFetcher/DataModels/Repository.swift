//
//  Repository.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

struct Repository: Codable, StarStatus {
    var isStarred: Bool = false
    
    var name: String
    var owner: Owner
    var description: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case description
        case url = "html_url"
    }
}

protocol StarStatus {
    var isStarred: Bool { get }
}
