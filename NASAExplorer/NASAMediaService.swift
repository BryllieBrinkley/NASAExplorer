//
//  NASAMediaService.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/27/26.
//

import Foundation

struct NASAMediaService {
    func fetchNASAMedia(query: String) async throws ->  [NASAItem] {
    
        var components = URLComponents(string: "https://images-api.nasa.gov/search")
        
        components?.queryItems = [URLQueryItem(name: "q", value: query), URLQueryItem(name: "media_type", value: "image")]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try decoder.decode(
                NASASearchResponse.self,
                from: data
            )
            
            return result.collection.items
            
        } catch {
            throw APIError.invalidData
        }
    }
    
}
