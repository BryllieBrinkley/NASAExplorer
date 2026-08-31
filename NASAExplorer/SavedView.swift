import SwiftUI
import SwiftData

struct SavedView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var savedItems: [SavedNASAItem]
    
    var body: some View {
        NavigationStack {
            ZStack {
                    AppColors.spaceGradient
                        .ignoresSafeArea()
                Group {
                    if savedItems.isEmpty {
                        ContentUnavailableView("No Saved Items", systemImage: "scroll", description: Text("New saved items will appear here."))
                            .foregroundStyle(AppColors.primaryText)
                            .fontWidth(.expanded)
                    } else {
                            List {
                                ForEach(savedItems) { item in
                                    SavedNASAItemCard(item: item)
                                }.onDelete { offsets in
                                    for index in offsets {
                                        modelContext.delete(savedItems[index])
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Saved")
            }
        }
    }
    
}

struct SavedNASAItemCard: View {
    let item: SavedNASAItem
    var body: some View {
        
        if let imageURL = item.imageURL,
           let url = URL(string: imageURL) {
            HStack(spacing: 14) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 120, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading , spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    if let description = item.itemDescription { Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

#Preview {
    SavedView().modelContainer(for: SavedNASAItem.self, inMemory: true)
}
