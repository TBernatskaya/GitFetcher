//
//  RepositoriesViewModelTests.swift
//  GitFetcherTests
//
//  Created by Tatiana Bernatskaya on 2018-10-14.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import GitFetcher

class RepositoriesViewModelTests: XCTestCase {
    
    lazy var testBundle = Bundle(for: type(of: self))
    let host = "api.github.com"
    
    class MockClass: RepositoriesUpdateListener {
        
        let viewModel: RepositoriesViewModel
        let expectation: XCTestExpectation
        
        init(with viewModel: RepositoriesViewModel, expectation: XCTestExpectation) {
            self.viewModel = viewModel
            self.expectation = expectation
        }
        
        func didUpdateRepositories() {
            guard let repositories = viewModel.repositories else { return XCTFail("Repositories list is empty") }
            
            XCTAssertEqual(repositories.count, 1)
            XCTAssertTrue(repositories[0].isStarred)
            expectation.fulfill()
        }
        
        func didReceive(error: Error) {
            return XCTFail("Repositories list is empty")
        }
    }
    
    override func setUp() {
        if let path = testBundle.path(forResource: "repos", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            stub(condition: isHost(self.host)) { _ in
                return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
            }
        } else {
            XCTFail("Cannot read json test file")
        }
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testRepositoriesViewModel() {
        let expectation = XCTestExpectation.init(description: "Waiting for response")
        
        guard let path = testBundle.path(forResource: "repos", ofType: "json") else { return XCTFail("Cannot read json test file") }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let reposArray = try! JSONDecoder().decode([Repository].self, from: data)
        
        let starredRepos = StarredRepositoriesCache.init()
        starredRepos.repositoryIDs = reposArray.compactMap{ $0.id }
        
        let viewModel = RepositoriesViewModel.init(with: "TBernatskaya", starredRepositories: starredRepos)
        
        let mockClass = MockClass.init(with: viewModel, expectation: expectation)
        viewModel.delegate = mockClass
        
        wait(for: [expectation], timeout: 10.0)
    }
}
