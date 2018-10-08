//
//  ApiService.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRequestKey: String {
    
    case repos = "https://api.github.com/users/{username}/repos"
    case star = "https://api.github.com/TBernatskaya/starred/{username}/{reponame}"
}

let headers = ["Authorization": "Bearer \("xxx")"]

class ApiService {

    func repositories(for username: String, completion: @escaping ([Repository]?, Error?) -> ()) {
        
        let endpointString = ApiRequestKey.repos.rawValue.replacingOccurrences(of: "{username}", with:username)
        
        if let endpointUrl = URL.init(string: endpointString) {
            self.request(url: endpointUrl, completion: { data, error in
                let decoder = JSONDecoder()
                if
                    let data = data,
                    let repositories = try? decoder.decode([Repository].self, from: data) {
                    completion(repositories, nil)
                } else {
                    completion(nil, error)
                }
            })
        }
    }
    
    func star(repository: String, owner: String) {
        let endpointString = ApiRequestKey.star.rawValue.replacingOccurrences(of: "{username}", with:owner).replacingOccurrences(of: "{reponame}", with: repository)
        
        if let endpointUrl = URL.init(string: endpointString) {
            self.request(url: endpointUrl, completion: { data, error in
                print(data!)
                print(error!)
            })
        }
    }
}

fileprivate extension ApiService {
    
    func request(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        
        Alamofire.request(method: .put, url, headers: headers).responseData { response in
            switch response.result {
            case .success:
                completion(response.data, response.error)
                
            case .failure:
                completion(nil, response.error)
            }
        }
    }
}
