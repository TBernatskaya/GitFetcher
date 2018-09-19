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
}

class ApiService {

    func repositories(for username: String, completion: @escaping ([Repository]) -> ()) {
        
        let endpointString = ApiRequestKey.repos.rawValue.replacingOccurrences(of: "{username}", with:username)
        
        if let endpointUrl = URL.init(string: endpointString) {
            self.request(url: endpointUrl, completion: { data in
                let decoder = JSONDecoder()
                if let repositories = try? decoder.decode([Repository].self, from: data) {
                    completion(repositories)
                }
            })
        }
    }
}

fileprivate extension ApiService {
    
    func request (url: URL, completion: @escaping (Data) -> ()){
        
        Alamofire.request(url).responseData { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    completion(data)
                } else {
                    print("No data received")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
