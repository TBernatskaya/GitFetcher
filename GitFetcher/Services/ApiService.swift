//
//  ApiService.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation
import Alamofire

fileprivate enum StatusCode: Int {
    case ok = 200
    case done = 204
}

fileprivate enum ApiError: Error {
    case errorStatusCode
}

fileprivate let headers = ["Authorization": "Bearer \("xxx")"]

protocol ApiService: ApiHelper {}

extension ApiService {
    
    typealias ResponseResult = (Data?, Error?) -> ()
    
    func repositories(for username: String, completion: @escaping ([Repository]?, Error?) -> ()) {
        guard let endpointUrl = reposEndpoint(username: username) else { return }
        
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
    
    func star(repository: String, owner: String, completion: @escaping (Error?) -> ()) {
        guard let endpointUrl = starToggleEndpoint(repository: repository, username: owner) else { return }
        
        self.request(url: endpointUrl, method: .put, headers: headers, completion: { data, error in
            // Success in case Status: 204 No Content
            completion(error)
        })
    }
    
    func unstar(repository: String, owner: String, completion: @escaping (Error?) -> ()) {
        guard let endpointUrl = starToggleEndpoint(repository: repository, username: owner) else { return }
        
        self.request(url: endpointUrl, method: .delete, headers: headers, completion: { data, error in
            // Success in case Status: 204 No Content
            completion(error)
        })
    }
    
    func starList(completion: @escaping ([Repository]?, Error?) -> ()) {
        guard let endpointUrl = starListEndpoint() else { return }
        
        self.request(url: endpointUrl, method: .get, headers: headers, completion: { data, error  in
            let decoder = JSONDecoder()
            guard
                let data = data,
                let repositories = try? decoder.decode([Repository].self, from: data)
            else { return completion(nil, error) }
            
            completion(repositories, nil)
        })
    }
}

fileprivate extension ApiService {
    
    func request(url: URL, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ResponseResult) {
        
        Alamofire.request(url, method: method, headers: headers).responseData { response in
            switch response.result {
            case .success:
                if (response.response?.statusCode == StatusCode.ok.rawValue ||
                    response.response?.statusCode == StatusCode.done.rawValue) {
                    
                    completion(response.data, response.error)
                } else {
                    completion(nil, ApiError.errorStatusCode)
                }
                
            case .failure:
                completion(nil, response.error)
            }
        }
    }
}
