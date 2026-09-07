import Foundation

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
