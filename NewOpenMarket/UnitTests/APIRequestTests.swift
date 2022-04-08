//
//  APIRequestTests.swift
//  UnitTests
//
//  Created by 유재호 on 2022/04/07.
//

import XCTest
@testable import NewOpenMarket

final class APIRequestTests: XCTestCase {
    
    // private var testItemID: Int? = nil
    // 외부 프로퍼티에 잠깐 저장했다가, ItemDetail 가져오는 비동기 작업에서 사용하려 했는데...
    
    func test_A_API_HealthChecker_response_검증() {
        let expectation = expectation(description: "response 로 OK 들어와야 함")
        
        API.HealthChecker().execute { result in
            XCTAssertEqual(try! result.get(), "OK")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_B_API_FetchItemsPage_response_검증() {
        let expectation = expectation(description: "item 5개 달라고 하면, 정확하게 5개 넘어와야 함")
        
        API.FetchItemsPage(pageNo: 1, itemsPerPage: 5).execute { result in
            let itemsPage = try! result.get()
            XCTAssertFalse(itemsPage.hasPrev)
            XCTAssertEqual(itemsPage.pageNo, 1)
            XCTAssertEqual(itemsPage.items.count, 5)
            // self.testItemID = itemsPage.items.first!.id
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func test_C_API_FetchItemDetail_response_검증() {
        let expectation = expectation(description: "item 상세 정보가 잘 들어와야 함")
        
        API.FetchItemDetail(itemID: 1936).execute { result in
            let itemDetail = try! result.get()
            XCTAssertNotNil(itemDetail.description)
            XCTAssertNotNil(itemDetail.images)
            XCTAssertNotNil(itemDetail.vendor)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
