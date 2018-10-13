//
//  Repository.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

class Repository: Codable {
    var id: Int
    var name: String
    var owner: Owner
    var description: String
    var url: URL
    var isFork: Bool
    
    var isStarred: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case url = "html_url"
        case isFork = "fork"
    }
}
