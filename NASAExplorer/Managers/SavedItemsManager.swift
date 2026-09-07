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
            print("item saved")
        } catch {
            print("save failed", error)
        }
    }
    
    static func delete(item: SavedNASAItem, context: ModelContext) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("failed to delete")
        }
    }
}
