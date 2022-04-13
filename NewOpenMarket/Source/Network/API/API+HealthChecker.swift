//
//  API+HealthChecker.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/07.
//

import Foundation

extension API {
    
    struct HealthChecker: APIRequest {
        
        var httpMethod: HTTPMethod = .get
        var path: String = "/healthChecker"
        var query: [String: Int] = [:]
        var body: Data?
        var headers: [String: String] = [:]
        var responseType = String.self
        
        init() { }
    }
}
