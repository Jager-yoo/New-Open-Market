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
    
    func test_API_AddItem_FindItemSecret_DeleteItem_통합_검증() async throws {
        // 서버에 아이템 등록
        let testImage = [UIImage(named: "image_sample")!]
        let addResponse = try await API.AddItem(
            images: testImage,
            name: "테스트",
            descriptions: "유닛 테스트를 통한 자동 업로드입니다.",
            currency: .krw,
            price: "1000",
            discount: "",
            stock: ""
        ).asyncExecute()
        
        XCTAssertEqual(addResponse.name, "테스트")
        XCTAssertEqual(addResponse.description, "유닛 테스트를 통한 자동 업로드입니다.")
        
        // 등록한 아이템의 삭제를 위한 Secret 확인
        let secretData = try await API.FindItemSecret(itemID: addResponse.id).asyncExecute()
        let secret = String(data: secretData, encoding: .utf8)!
        
        XCTAssertFalse(secret.isEmpty)
        
        // 아이템 삭제 요청
        let deleteResponse = try await API.DeleteItem(itemID: addResponse.id, itemSecret: secret).asyncExecute()
        
        XCTAssertEqual(deleteResponse.id, addResponse.id)
    }
}
