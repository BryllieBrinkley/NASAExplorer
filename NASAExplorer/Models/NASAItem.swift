
import Foundation

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
