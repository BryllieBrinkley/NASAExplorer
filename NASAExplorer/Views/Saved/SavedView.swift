import SwiftUI
import SwiftData

struct SavedView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var savedItems: [SavedNASAItem]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                if savedItems.isEmpty {
                    ContentUnavailableView(
                        "No Saved Items",
                        systemImage: "bookmark",
                        description: Text("Saved NASA media will appear here.")
                    )
                    .foregroundStyle(AppColors.primaryText)
                    
                } else {
                    List {
                        ForEach(savedItems) { item in
                            SavedNASAItemCard(item: item)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            SavedItemsManager.delete(
                item: savedItems[index],
                context: modelContext
            )
        }
    }
}

#Preview {
    SavedView().modelContainer(for: SavedNASAItem.self, inMemory: true)
}
