import Foundation
import SwiftData

struct SavedItemsManager {

    static func save(
        item: NASAItem,
        context: ModelContext
    ) {
        guard let data = item.data.first,
              let nasaID = item.details?.nasaId else {
            return
        }

        let savedItem = SavedNASAItem(
            nasaID: nasaID,
            title: data.title ?? "Untitled",
            itemDescription: data.description,
            mediaType: data.mediaType,
            imageURL: item.previewURL?.absoluteString,
            dateCreated: data.dateCreated
        )

        context.insert(savedItem)

        do {
            try context.save()
            print("✅ Saved item")
        } catch {
            print("❌ Save failed:", error)
        }
    }
}
