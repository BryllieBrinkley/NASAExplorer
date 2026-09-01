import SwiftUI
import SwiftData

struct NASAItemDetailView: View {
    let item: NASAItem
    @Environment(\.modelContext) var context

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncImage(url: item.previewURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(item.details?.title ?? "Untitled")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.primaryText)

                    Text(item.details?.description ?? "No description available.")
                        .foregroundStyle(AppColors.secondaryText)

                    if let nasaID = item.details?.nasaId {
                        Text("NASA ID: \(nasaID)")
                            .font(.caption)
                            .foregroundStyle(AppColors.tertiaryText)
                    }
                    
                    
                    Button {
                        print("button pressed")
                    } label: {
                        Label("Save", systemImage: "heart")
                            .foregroundStyle(AppColors.starGold)
                        
                    }

                    

                    
                }
                .padding()
            }
        }
        .navigationTitle("NASA Media")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview("NASA Item Detail") {
    NavigationStack {
        NASAItemDetailView(
            item: NASAItem(
                data: [
                    NASAImageData(
                        center: "JPL",
                        dateCreated: "2026-09-01T00:00:00Z",
                        description: "A detailed preview description of a NASA image. This sample data is only used to design the SwiftUI layout.",
                        keywords: ["NASA", "James Webb", "Space"],
                        location: "Deep Space",
                        mediaType: "image",
                        nasaId: "PIA12345",
                        photographer: "NASA",
                        title: "James Webb Space Telescope"
                    )
                ],
                links: [
                    NASAImageLink(
                        href: "https://images-assets.nasa.gov/image/PIA12348/PIA12348~orig.jpg",
                        rel: "preview",
                        render: "image"
                    )
                ]
            )
        )
    }
    .modelContainer(
        for: SavedNASAItem.self,
        inMemory: true
    )
}
