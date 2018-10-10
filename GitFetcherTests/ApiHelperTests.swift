//
//  ApiHelperTests.swift
//  GitFetcherTests
//
//  Created by Tatiana Bernatskaya on 2018-10-09.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
@testable import GitFetcher

class ApiHelperTests: XCTestCase {
    
    class MockClass: ApiHelper {}
    
    func testReposEndpoint() {
        let mock = MockClass()
        let username = "Myname"
        let expectedResult = URL.init(string: "https://api.github.com/users/Myname/repos")
        let actualResult = mock.reposEndpoint(username: username)
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testStarEndpoint() {
        let mock = MockClass()
        let username = "Myname"
        let repositoryName = "Repo"
        let expectedResult = URL.init(string: "https://api.github.com/user/starred/Myname/Repo")
        let actualResult = mock.starToggleEndpoint(repository: repositoryName, username: username)
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testStarListEndpoint() {
        let mock = MockClass()
        let expectedResult = URL.init(string: "https://api.github.com/user/starred")
        let actualResult = mock.starListEndpoint()
        
        XCTAssertEqual(expectedResult, actualResult)
    }
}
