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
            modelContext.delete(savedItems[index])
        }
    }
}

struct SavedNASAItemCard: View {

    let item: SavedNASAItem

    var body: some View {
        HStack(spacing: 14) {

            if let imageURL = item.imageURL,
               let url = URL(string: imageURL) {

                AsyncImage(url: url) { phase in
                    switch phase {

                    case .empty:
                        ProgressView()

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        imagePlaceholder

                    @unknown default:
                        imagePlaceholder
                    }
                }
                .frame(width: 110, height: 100)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

            } else {
                imagePlaceholder
                    .frame(width: 110, height: 100)
            }

            VStack(alignment: .leading, spacing: 6) {

                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(2)

                if let description = item.itemDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(3)
                }

                Spacer()
            }
        }
        .padding()
        .background(AppColors.surface)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }

    private var imagePlaceholder: some View {
        ZStack {
            AppColors.surface

            Image(systemName: "photo")
                .font(.title)
                .foregroundStyle(AppColors.secondaryText)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}

#Preview {
    SavedView().modelContainer(for: SavedNASAItem.self, inMemory: true)
}
