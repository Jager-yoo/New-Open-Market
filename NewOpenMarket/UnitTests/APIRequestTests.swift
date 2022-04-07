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
}
