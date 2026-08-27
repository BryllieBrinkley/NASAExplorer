import Foundation
import Observation

@Observable
final class ExploreViewModel {

    var results: [NASAItem] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    func searchNASAMedia(query: String) async {
        guard !query.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            results = try await fetchNASAMedia(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
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
