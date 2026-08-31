import Foundation
import SwiftData



//Model: Data
// Container: Where things get saved
// Context : How you interact with the data


@Model
final class SavedNASAItem {
    var nasaID: String
    var title: String
    var itemDescription: String
    var imageUrl: String?
    var dateCreated: String?
    var photographer: String?
    var location: String?
    var savedAt: Date
    
    
    init(nasaID: String, title: String, itemDescription: String, imageUrl: String? = nil, dateCreated: String? = nil, photographer: String? = nil, location: String? = nil, savedAt: Date) {
        self.nasaID = nasaID
        self.title = title
        self.itemDescription = itemDescription
        self.imageUrl = imageUrl
        self.dateCreated = dateCreated
        self.photographer = photographer
        self.location = location
        self.savedAt = savedAt
    }
    
}
