import Foundation

enum ContentCategory: String, CaseIterable, Identifiable, Hashable {
    
    case missions
    case planets
    case asteroids
    case nasaImages

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .planets:
            return "Planets"
        case .missions:
            return "Missions"
        case .asteroids:
            return "Asteroids"
        case .nasaImages:
            return "NASA Official Images"
        }
    }

    var imageName: String {
        switch self {
        case .planets:
            return "planets-card-bg"
        case .missions:
            return "missions-card-bg"
        case .asteroids:
            return "asteroid-card-bg"
        case .nasaImages:
            return "nasa-images-card-bg"
        }
    }

    var searchQuery: String {
        switch self {
        case .planets:
            return "solar system planets"
        case .missions:
            return "NASA missions"
        case .asteroids:
            return "asteroids"
        case .nasaImages:
            return "NASA"
        }
    }
}
