//
//  JSONManager.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import Foundation

struct JSONManager {
    
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        return dateFormatter
    }()
    
    func decode<T: Decodable>(from data: Data) throws -> T {
        Self.decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
        // If the data isn’t valid JSON, this method throws the DecodingError.dataCorrupted(_:) error.
        // If a value within the JSON fails to decode, this method throws the corresponding error.
        let decodedType = try Self.decoder.decode(T.self, from: data)
        return decodedType
    }
    
    func encode<T: Encodable>(from data: T) throws -> Data {
        // If there’s a problem encoding the value you supply, this method throws an error based on the type of problem.
        let encodedData = try Self.encoder.encode(data)
        return encodedData
    }
}
