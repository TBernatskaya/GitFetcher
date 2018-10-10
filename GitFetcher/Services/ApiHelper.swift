//
//  ApiHelper.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

fileprivate enum Servers: String {
    case main = "https://api.github.com"
}

fileprivate enum ApiRoute: String {
    case repos = "/users/{username}/repos"
    case star = "/user/starred/{username}/{reponame}"
}

protocol ApiHelper {}

extension ApiHelper {
    
    func reposEndpoint(username: String) -> URL? {
        let endpointString = Servers.main.rawValue +
                            ApiRoute.repos.rawValue.replacingOccurrences(of: "{username}", with:username)
        return URL.init(string: endpointString)
    }
    
    func starEndpoint(repository: String, username: String) -> URL? {
        let endpointString = Servers.main.rawValue +
                            ApiRoute.star.rawValue.replacingOccurrences(of: "{username}", with:username)
                            .replacingOccurrences(of: "{reponame}", with: repository)
        
        return URL.init(string: endpointString)
    }
}
