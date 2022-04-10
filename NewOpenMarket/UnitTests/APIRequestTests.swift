//
//  APIRequestTests.swift
//  UnitTests
//
//  Created by 유재호 on 2022/04/07.
//

import XCTest
@testable import NewOpenMarket

final class APIRequestTests: XCTestCase {
    
    func test_API_HealthChecker_response_검증() async throws {
        let message = try await API.HealthChecker().asyncExecute()
        
        XCTAssertEqual(message, "OK")
    }
    
    func test_API_FetchItemsPage_response_검증() async throws {
        let itemsPage = try await API.FetchItemsPage(pageNo: 1, itemsPerPage: 5).asyncExecute()
        
        XCTAssertFalse(itemsPage.hasPrev)
        XCTAssertEqual(itemsPage.pageNo, 1)
        XCTAssertEqual(itemsPage.itemsPerPage, 5)
        XCTAssertEqual(itemsPage.items.count, 5)
        XCTAssertEqual(itemsPage.limit, 5)
    }
    
    func test_API_FetchItemDetail_response_검증() async throws {
        let targetItem = try await API.FetchItemsPage(pageNo: 1, itemsPerPage: 1).asyncExecute().items.first!
        let itemDetail = try await API.FetchItemDetail(itemID: targetItem.id).asyncExecute()
        
        XCTAssertNotNil(itemDetail.description)
        XCTAssertNotNil(itemDetail.images)
        XCTAssertNotNil(itemDetail.vendor)
    }
}
