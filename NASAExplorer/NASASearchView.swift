import SwiftUI
import SwiftData

struct NASAResultsView: View {
    
    let query: String
    let viewModel: ExploreViewModel
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Searching NASA")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView("Search Failed!", image: "exclamationmark.triangle", description: Text(errorMessage))
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.results) { item in
                            NavigationLink {
                                NASAItemDetailView(item: item)
                            } label: {
                                NASASearchResultCard(item: item)
                                    .foregroundStyle(.black)
                            }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Results for \(query)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NASASearchResultCard: View {
    let item: NASAItem
    @Environment(\.modelContext) var context
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: item.previewURL) { phase in
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

            VStack(alignment: .trailing , spacing: 6) {
                Text(item.data.first?.title ?? "Untitled")
                    .font(.headline)
                    .lineLimit(2)

                Text(item.data.first?.description ?? "No description")
                    .font(.caption)
                    .foregroundStyle(.black)
                    .lineLimit(3)
            }

            Spacer()
            
            Button {
//                let newItem = SavedNASAItem(nasaID: <#T##String#>, title: <#T##String#>, itemDescription: <#T##String#>, savedAt: <#T##Date#>)
//                
//
//                context.insert(newItem)
                
                print("bookmark pressed")
                
            } label: {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.secondary)
            }

        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


#Preview("NASAResultsView") {
    let viewModel = ExploreViewModel(
        mediaService: NASAMediaService()
    )

    NASAResultsView(
        query: "Mars",
        viewModel: viewModel
    )
    .task {
        await viewModel.searchNASAMedia(query: "Mars")
    }
}




#Preview("NASA Result Card") {
    NASASearchResultCard(
        item: NASAItem(
            data: [
                NASAImageData(
                    center: "JPL",
                    dateCreated: "2026-08-30T00:00:00Z",
                    description: "NASA's Perseverance rover exploring the surface of Mars.",
                    keywords: ["Mars", "Rover", "Perseverance"],
                    location: "Mars",
                    mediaType: "image",
                    nasaId: "PIA25681",
                    photographer: "NASA/JPL-Caltech",
                    title: "Exploring the Surface of Mars"
                )
            ],
            links: [
                NASAImageLink(
                    href: "https://images-assets.nasa.gov/image/PIA25681/PIA25681~thumb.jpg",
                    rel: "preview",
                    render: "image"
                )
            ]
        )
    )
    .padding()
    .background(AppColors.background)
}
