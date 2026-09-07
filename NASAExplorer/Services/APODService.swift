import Foundation

protocol APODServicing {
    func fetchAPOD() async throws -> PictureOfDay
    func fetchCachedAPOD() -> PictureOfDay?
    func cacheAPOD(_ picture: PictureOfDay)
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

final class APODService: APODServicing {
    private let session: URLSession
    private let cachedAPODKey = "cachedAPOD"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchAPOD() async throws -> PictureOfDay {
        // Read API key
        let configuredKey: String
        do {
            configuredKey = try AppConfiguration.nasaAPIKey
        } catch {
            configuredKey = "DEMO_KEY"
        }
        let trimmed = configuredKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let apiKey = trimmed.isEmpty ? "DEMO_KEY" : trimmed

        // Build URL
        var components = URLComponents(string: "https://api.nasa.gov/planetary/apod")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "thumbs", value: "true")
        ]
        guard let url = components?.url else { throw APIError.invalidURL }

        // Request
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            return try handleNon2xx(data: data)
        }

        // Decode
        do {
            let pod = try JSONDecoder().decode(PictureOfDay.self, from: data)
            return pod
        } catch {
            // Log raw body for diagnostics
            if let body = String(data: data, encoding: .utf8) {
                print("❌ APOD decode failed. Raw body:\n", body)
            }
            throw APIError.invalidData
        }
    }

    private func handleNon2xx(data: Data) throws -> PictureOfDay {
        if let body = String(data: data, encoding: .utf8) {
            print("❌ APOD non-2xx body:\n", body)
        }
        throw APIError.invalidResponse
    }

    // MARK: - Caching
    func cacheAPOD(_ picture: PictureOfDay) {
        do {
            let data = try JSONEncoder().encode(picture)
            UserDefaults.standard.set(data, forKey: cachedAPODKey)
        } catch {
            print("Failed to cache APOD:", error)
        }
    }

    func fetchCachedAPOD() -> PictureOfDay? {
        guard let data = UserDefaults.standard.data(forKey: cachedAPODKey) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(PictureOfDay.self, from: data)
        } catch {
            print("Failed to load cached APOD:", error)
            return nil
        }
    }
}
