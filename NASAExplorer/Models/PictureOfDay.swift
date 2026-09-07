import Foundation

struct PictureOfDay: Codable {
    let copyright: String?
    let explanation: String
    let pictureURL: URL
    let title: String
    let mediaType: String?
    let thumbnailURL: String?
    enum CodingKeys: String, CodingKey {
        case copyright
        case explanation
        case title
        case pictureURL = "url"
        case mediaType = "media_type"
        case thumbnailURL = "thumbnail_url"
    }
}
