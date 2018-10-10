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
    case starToggle = "/user/starred/{username}/{reponame}"
    case starList = "/user/starred"
}

protocol ApiHelper {}

extension ApiHelper {
    
    func reposEndpoint(username: String) -> URL? {
        let endpointString = Servers.main.rawValue +
                            ApiRoute.repos.rawValue.replacingOccurrences(of: "{username}", with:username)
        return URL.init(string: endpointString)
    }
    
    func starToggleEndpoint(repository: String, username: String) -> URL? {
        let endpointString = Servers.main.rawValue +
                            ApiRoute.starToggle.rawValue.replacingOccurrences(of: "{username}", with:username)
                            .replacingOccurrences(of: "{reponame}", with: repository)
        
        return URL.init(string: endpointString)
    }
    
    func starListEndpoint() -> URL? {
        let endpointString = Servers.main.rawValue + ApiRoute.starList.rawValue
        return URL.init(string: endpointString)
    }
}
