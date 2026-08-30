
import Foundation

struct NASASearchResponse: Decodable {
    let collection: NASACollection
}

struct NASACollection: Decodable {
    let items: [NASAItem]
}

struct NASAImageData: Decodable {
    let center: String?
    let dateCreated: String?
    let description: String?
    let keywords: [String]?
    let location: String?
    let mediaType: String?
    let nasaId: String?
    let photographer: String?
    let title: String?
}

struct NASAItem: Decodable, Identifiable {
    let data: [NASAImageData]
    let links: [NASAImageLink]?
    
    var id: String {
        data.first?.nasaId ?? links?.first?.href ?? "unknown"
    }
    
    var details: NASAImageData? {
        data.first
    }
    
    var previewURL: URL? {
        guard let href = links?.first?.href else {
            return nil
        }
        return URL(string: href)
    }
}

struct NASAImageLink: Decodable {
    let href: String
    let rel: String?
    let render: String?
}
