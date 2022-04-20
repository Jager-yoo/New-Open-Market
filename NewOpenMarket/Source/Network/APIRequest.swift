//
//  APIRequest.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/07.
//

import Foundation

protocol APIRequest {
    
    associatedtype APIResponse: Decodable
    
    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var query: [String: Int] { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var responseType: APIResponse.Type { get }
    var jsonManager: JSONManager { get }
}

extension APIRequest {
    
    var identifier: String {
        return "a3daae1d-7215-11ec-abfa-57090eab9093"
    }
    
    var boundary: String {
        // 호출될 때 마다 boundary 가 달라지면, 에러날 수도 있음! (연산 프로퍼티 주의)
        return "XXXXXX"
    }
    
    var lineBreak: String {
        return "\r\n"
    }
    
    var baseURLString: String {
        return "https://market-training.yagom-academy.kr"
    }
    
    var url: URL? {
        var urlComponents = URLComponents(string: baseURLString + path)
        urlComponents?.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    var jsonManager: JSONManager {
        return JSONManager()
    }
    
    func execute(_ completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let urlRequest = urlRequest else {
            // @escaping 키워드를 사용하면 completion 뒤에 옵셔널 체이닝이 불필요함!
            // -> completion?(.failure(APIError.invalidURL)) 이렇게 써야 하거든
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.invalidServerResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidServerResponse))
                return
            }
            
            do {
                let decodedData: APIResponse = try jsonManager.decode(from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func asyncExecute() async throws -> APIResponse {
        guard let urlRequest = urlRequest else {
            throw APIError.invalidURLRequest
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidServerResponse
        }
        
        guard (200...201).contains(httpResponse.statusCode) else {
            print("⚠️ Status Code -> \(httpResponse.statusCode)")
            throw APIError.invalidServerResponse
        }
        
        let decodedData: APIResponse = try jsonManager.decode(from: data)
        
        return decodedData
    }
}
