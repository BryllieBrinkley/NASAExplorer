import Foundation

enum AppConfiguration {
    static var nasaAPIKey: String {
        get throws {
            guard let raw = Bundle.main.object(
                forInfoDictionaryKey: "NASA_API_KEY"
            ) as? String else {
                throw ConfigurationError.missingNASAAPIKey
            }
            let key = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !key.isEmpty,
                  key != "$(NASA_API_KEY)",
                  key != "INSERT_YOUR_NASA_API_KEY" else {
                throw ConfigurationError.missingNASAAPIKey
            }
            return key
        }
    }
}

enum ConfigurationError: LocalizedError {
    case missingNASAAPIKey
    
    var errorDescription: String? {
        switch self {
        case .missingNASAAPIKey:
            return "The NASA API key is missing from the build configuration."
        }
    }
}

