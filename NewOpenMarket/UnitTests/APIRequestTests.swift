//
//  APIRequestTests.swift
//  UnitTests
//
//  Created by 유재호 on 2022/04/07.
//

import XCTest
@testable import NewOpenMarket

final class APIRequestTests: XCTestCase {
    
    func test_API_HealthChecker_response_검증() {
        let expectation = expectation(description: "response 로 OK 들어와야 함")
        
        API.HealthChecker().execute { result in
            XCTAssertEqual(try! result.get(), "OK")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_API_FetchItemsPage_response_검증() {
        let expectation = expectation(description: "item 5개 달라고 하면, 정확하게 5개 넘어와야 함")
        
        API.FetchItemsPage(pageNo: 1, itemsPerPage: 5).execute { result in
            let itemsPage = try! result.get()
            XCTAssertFalse(itemsPage.hasPrev)
            XCTAssertEqual(itemsPage.pageNo, 1)
            XCTAssertEqual(itemsPage.items.count, 5)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
