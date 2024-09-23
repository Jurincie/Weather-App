//
//  ApiService.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import Foundation
import SwiftUI

enum ApiError: Error, CustomStringConvertible {
    case badURL
    case decodingError
    case badURLResponse
    case unknownError
    
    var description: String {
        switch(self) {
        case .badURL: return "Could NOT make URL from given string."
        case .badURLResponse: return "Received response Error on fetch request."
        case .decodingError: return "Error during JSON decoding."
        case .unknownError: return "Unknown Error"
        }
    }
}

enum ApiService {
    /// Generic method that returns Decodable type from Api via urlString
    /// - Parameter urlString: querys
    /// - Returns: Type
    static func fetch<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw ApiError.badURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } else {
                    throw ApiError.badURLResponse
                }
            }
        } catch {
            throw ApiError.decodingError
        }
        
        throw ApiError.unknownError
    }
}
