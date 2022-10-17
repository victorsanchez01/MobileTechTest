//
//  TableViewUnitTests.swift
//
//  Created by victor.sanchez on 16/10/22.
//

import XCTest
@testable import MobileTechTest

class PostsTableViewUnitTests: XCTestCase {

    //Tests that tableview is not nil on Posts View
    func testTableViewIsNotNil() {
        let viewController = createSUT()
        _ = viewController.view
        
        XCTAssertNotNil(viewController.tableView)
    }
    
    private func createSUT() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
}

class PostDetailsTableViewUnitTests: XCTestCase {
    var viewController: PostDetailsViewController!
    
    override func setUpWithError() throws {
        viewController = PostDetailsViewController(commentId: 1, postTitle: "", postDescription: "", authorName: "", authorUserName: "", authorEmail: "", authorCity: "")
        viewController.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
    }
    
    
    //Tests that tableview is not nil on PostDetails View
    func testTableViewIsNotNil() {

        _ = viewController.view
        
        XCTAssertNotNil(viewController.tableView)
    }
}
