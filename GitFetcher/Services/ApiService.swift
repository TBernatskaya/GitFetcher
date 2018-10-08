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
    case star = "https://api.github.com/user/starred/{username}/{reponame}"
}

enum StatusCode: Int {
    case ok = 200
    case done = 204
}

enum ApiError: Error {
    case wrongStatus
}

typealias ResponseResult = (Data?, Error?) -> ()
let headers = ["Authorization": "Bearer \("xxx")"]

class ApiService {

    func repositories(for username: String, completion: @escaping ([Repository]?, Error?) -> ()) {
        let endpointString = ApiRequestKey.repos.rawValue.replacingOccurrences(of: "{username}", with:username)
        
        if let endpointUrl = URL.init(string: endpointString) {
            self.request(url: endpointUrl, method: .get, headers: [:], completion: { data, error  in
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
    
    func star(repository: String, owner: String, completion: @escaping (Bool, Error?) -> ()) {
        guard let endpointUrl = starEndpoint(repository: repository, owner: owner) else { return }
        
        self.request(url: endpointUrl, method: .put, headers: headers, completion: { data, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
                print("starred!")
            }
        })
    }
    
    func unstar(repository: String, owner: String, completion: @escaping (Bool, Error?) -> ()) {
        guard let endpointUrl = starEndpoint(repository: repository, owner: owner) else { return }
        
        self.request(url: endpointUrl, method: .delete, headers: headers, completion: { data, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
                print("unstarred!")
            }
        })
    }
}

fileprivate extension ApiService {
    
    func starEndpoint(repository: String, owner: String) -> URL? {
        let endpointString = ApiRequestKey.star.rawValue.replacingOccurrences(of: "{username}", with:owner).replacingOccurrences(of: "{reponame}", with: repository)
        
        return URL.init(string: endpointString)
    }
    
    func request(url: URL, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ResponseResult) {
        
        Alamofire.request(url, method: method, headers: headers).responseData { response in
            switch response.result {
            case .success:
                if (response.response?.statusCode == StatusCode.ok.rawValue || response.response?.statusCode == StatusCode.done.rawValue) {
                    completion(response.data, response.error)
                } else {
                    completion(nil, ApiError.wrongStatus)
                }
                
            case .failure:
                completion(nil, response.error)
            }
        }
    }
}
