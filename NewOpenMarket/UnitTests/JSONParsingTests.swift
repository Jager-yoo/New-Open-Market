//
//  JSONParsingTests.swift
//  UnitTests
//
//  Created by 유재호 on 2022/04/06.
//

import XCTest
@testable import NewOpenMarket

final class JSONParsingTests: XCTestCase {
    
    private var sut: ItemsPage!
    private let jsonManager = JSONManager()
    private let mockJSONData = NSDataAsset(name: "items_page_sample")!.data

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = try jsonManager.decode(from: mockJSONData)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_mockJSON_디코딩_검증() {
        XCTAssertEqual(sut.pageNo, 1)
        XCTAssertEqual(sut.itemsPerPage, 20)
        XCTAssertEqual(sut.totalCount, 10)
        XCTAssertEqual(sut.offset, 0)
        XCTAssertEqual(sut.limit, 20)
        XCTAssertEqual(sut.items.count, 10)
        XCTAssertEqual(sut.lastPage, 1)
        XCTAssertEqual(sut.hasNext, false)
        XCTAssertEqual(sut.hasPrev, false)
    }
    
    func test_items배열의_첫번째item_디코딩_검증() {
        let firstItem = sut.items.first!
        XCTAssertEqual(firstItem.id, 20)
        XCTAssertEqual(firstItem.vendorID, 3)
        XCTAssertEqual(firstItem.thumbnail, URL(string: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg"))
        XCTAssertEqual(firstItem.currency, Currency.krw)
        XCTAssertEqual(firstItem.price, 0)
        XCTAssertEqual(firstItem.bargainPrice, 0)
        XCTAssertEqual(firstItem.discountedPrice, 0)
        XCTAssertEqual(firstItem.stock, 0)
        XCTAssertEqual(firstItem.createdAt, formatDate(from: "2022-01-04T00:00:00.00")!)
        XCTAssertEqual(firstItem.issuedAt, formatDate(from: "2022-01-04T00:00:00.00")!)
    }
    
    func test_item_상세정보용_프로퍼티는_nil_처리됐는지_검증() {
        let lastItem = sut.items.last!
        XCTAssertNil(lastItem.description)
        XCTAssertNil(lastItem.images)
        XCTAssertNil(lastItem.vendor)
    }
    
    private func formatDate(from date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        return dateFormatter.date(from: date)
    }
}
