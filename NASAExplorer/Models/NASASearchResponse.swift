import Foundation

struct NASASearchResponse: Decodable {
    let collection: NASACollection
}

struct NASACollection: Decodable {
    let items: [NASAItem]
}
struct NASAImageLink: Decodable {
    let href: String
    let rel: String?
    let render: String?
}

