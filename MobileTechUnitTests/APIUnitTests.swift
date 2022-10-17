//
//  APIUnitTests.swift
//
//  Created by victor.sanchez on 9/10/22.
//

import XCTest
@testable import MobileTechTest

class APIUnitTests: XCTestCase {
    var viewController: ViewController!
    var viewModel: ViewModel!
    
    
    override func setUpWithError() throws {
        viewController = ViewController()
        viewModel = ViewModel()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        viewModel = nil
    }
    
    //Test getting data from Author API
    func testGetDataFromAuthorAPI() {
        let responseExpected = XCTestExpectation(description: "Data from API received successfuly")
        var data: [Author]?
        viewController.fetchAuthor(authorId: 1) { result in
            switch result {
            case .success(let responsedata):
                data = [responsedata]
            case .failure(_):
                XCTFail("Error")
            }
            XCTAssertNotNil(data)
            responseExpected.fulfill()
        }
        wait(for: [responseExpected], timeout: 10)
    }
    
    //Test getting data from Comments API
    func testGetDataFromCommentsAPI() {
        let responseExpected = XCTestExpectation(description: "Data from API received successfuly")
        var wasSuccess: Bool?
        viewModel.fetchComments(commentId: 1) { result in
            switch result {
            case .success(let success):
                wasSuccess = success
            case .failure(_):
                XCTFail("Error")
            }
            XCTAssertTrue((wasSuccess != nil))
            responseExpected.fulfill()
        }
        wait(for: [responseExpected], timeout: 10)
    }
    
    //Test getting data from Posts API
    func testGetDataFromPostsAPI() {
        let responseExpected = XCTestExpectation(description: "Data from API received successfuly")
        var wasSuccess: Bool?
        
        viewController.fetchPosts() { result in
            switch result {
            case .success(let success):
                wasSuccess = success
            case .failure(_):
                XCTFail("Error")
            }
            XCTAssertTrue((wasSuccess != nil))
            responseExpected.fulfill()
        }
        wait(for: [responseExpected], timeout: 10)
    }
}
