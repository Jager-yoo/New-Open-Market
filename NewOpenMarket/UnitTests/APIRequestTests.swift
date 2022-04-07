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
        API.HealthChecker().execute { result in
            XCTAssertEqual(try! result.get(), "OK")
        }
    }
    
    func test_API_FetchItemsPage_response_검증() {
        API.FetchItemsPage(pageNo: 1, itemsPerPage: 10).execute { result in
            XCTAssertEqual(try! result.get().pageNo, 1)
            XCTAssertFalse(try! result.get().hasPrev)
        }
    }
}
