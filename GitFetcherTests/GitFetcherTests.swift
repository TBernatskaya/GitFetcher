//
//  GitFetcherTests.swift
//  GitFetcherTests
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import GitFetcher

class GitFetcherTests: XCTestCase {
    
    let host = "api.github.com"
    lazy var testBundle = Bundle(for: type(of: self))

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testExistingGitUser() {
        let apiService = ApiService.init()
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
        let apiService = ApiService.init()
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
    
    func testReceivedError() {
        let apiService = ApiService.init()
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        let notExistingUserName = "blah123"
        
        stub(condition: isHost(self.host)) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }
        
        apiService.repositories(for: notExistingUserName, completion: { repos, error in
            XCTAssertNil(repos)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
}
