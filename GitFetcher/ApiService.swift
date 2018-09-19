//
//  ApiService.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import Foundation
import Alamofire

struct DefaultSettings {
    var host: URL {
        get { return URL.init(string: "https://api.github.com/users/TBernatskaya/repos")! }
    }
    
    var method: HTTPMethod {
        get { return HTTPMethod.get }
    }
}

class ApiService {

    private let settings = DefaultSettings.init()
    
    func getRepos(for username: String) -> DataRequest? {
        
        
        
        
        return Alamofire.request(settings.host).responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
}
