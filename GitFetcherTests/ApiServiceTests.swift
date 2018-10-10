//
//  ApiServiceTests.swift
//  GitFetcherTests
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import GitFetcher

class ApiServiceTests: XCTestCase {
    
    class MockClass: ApiService {}
    
    let host = "api.github.com"
    lazy var testBundle = Bundle(for: type(of: self))
    let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testExistingGitUser() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let existingUserName = "TBernatskaya"
        let reposCount = 1
        
        if let path = testBundle.path(forResource: "repos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                stub(condition: isHost(self.host)) { _ in
                    return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                }
            } catch {
                XCTFail("Cannot read json test file")
            }
        }
        
        apiService.repositories(for: existingUserName, completion: { repos, error in
            XCTAssertNotNil(repos)
            XCTAssertNil(error)
            XCTAssertEqual(repos!.count, reposCount)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNotExistingGitUser() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let notExistingUserName = "blah123"
        let reposCount = 0
        
        if let path = testBundle.path(forResource: "empty", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                stub(condition: isHost(self.host)) { _ in
                    return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                }
            } catch {
                XCTFail("Cannot read json test file")
            }
        }
        
        apiService.repositories(for: notExistingUserName, completion: { repos, error in
            XCTAssertNotNil(repos)
            XCTAssertNil(error)
            XCTAssertEqual(repos!.count, reposCount)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGitUserReceivedError() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let notExistingUserName = "blah123"
        
        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error:self.notConnectedError)
        }
        
        apiService.repositories(for: notExistingUserName, completion: { repos, error in
            XCTAssertNil(repos)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testStarRepository() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let existingUserName = "TBernatskaya"
        let existingRepositoryName = "GitFetcher"
        
        stub(condition: isHost(self.host)) { _ in
            let response = OHHTTPStubsResponse.init()
            response.statusCode = 204
            return response
        }
        
        apiService.star(repository: existingRepositoryName, owner: existingUserName, completion: { succeeded, error in
            XCTAssertTrue(succeeded)
            XCTAssertNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testStarRepositoryReceivedError() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let existingUserName = "TBernatskaya"
        let existingRepositoryName = "GitFetcher"
        
        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error:self.notConnectedError)
        }
        
        apiService.star(repository: existingRepositoryName, owner: existingUserName, completion: { succeeded, error in
            XCTAssertFalse(succeeded)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testUnStarRepository() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let existingUserName = "TBernatskaya"
        let existingRepositoryName = "GitFetcher"
        
        stub(condition: isHost(self.host)) { _ in
            let response = OHHTTPStubsResponse.init()
            response.statusCode = 204
            return response
        }
        
        apiService.unstar(repository: existingRepositoryName, owner: existingUserName, completion: { succeeded, error in
            XCTAssertTrue(succeeded)
            XCTAssertNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testUnStarRepositoryReceivedError() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let existingUserName = "TBernatskaya"
        let existingRepositoryName = "GitFetcher"
        
        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error:self.notConnectedError)
        }
        
        apiService.unstar(repository: existingRepositoryName, owner: existingUserName, completion: { succeeded, error in
            XCTAssertFalse(succeeded)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testListStarred() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let reposCount = 1
        
        if let path = testBundle.path(forResource: "repos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                stub(condition: isHost(self.host)) { _ in
                    return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                }
            } catch {
                XCTFail("Cannot read json test file")
            }
        }
        
        apiService.starList(completion: { repos, error in
            XCTAssertNotNil(repos)
            XCTAssertNil(error)
            XCTAssertEqual(repos!.count, reposCount)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testListStarredReceivedError() {
        let apiService = MockClass()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        
        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error:self.notConnectedError)
        }
        
        apiService.starList(completion: { repos, error in
            XCTAssertNil(repos)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
}
