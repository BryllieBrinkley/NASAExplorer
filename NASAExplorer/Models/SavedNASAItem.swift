import Foundation
import SwiftData

//Model: Data
// Container: Where things get saved
// Context : How you interact with the data

@Model
final class SavedNASAItem {

    @Attribute(.unique)
    var nasaID: String

    var title: String
    var itemDescription: String?
    var mediaType: String?
    var imageURL: String?
    var dateCreated: String?

    var savedAt: Date = Date.now

    init(
        nasaID: String,
        title: String,
        itemDescription: String?,
        mediaType: String?,
        imageURL: String?,
        dateCreated: String?
    ) {
        self.nasaID = nasaID
        self.title = title
        self.itemDescription = itemDescription
        self.mediaType = mediaType
        self.imageURL = imageURL
        self.dateCreated = dateCreated
    }
}
