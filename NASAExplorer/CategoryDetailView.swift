import SwiftUI

struct CategoryDetailView: View {
    let category: ContentCategory
    @State private var results: [NASAItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let mediaService: NASAMediaService
    
    init(
        category: ContentCategory,
        mediaService: NASAMediaService = NASAMediaService()
    ) {
        self.category = category
        self.mediaService = mediaService
    }
    
    var body: some View {
        ZStack {
            AppColors.spaceGradient
                .ignoresSafeArea()
            
            Group {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .controlSize(.large)
                            .tint(AppColors.orbitalBlue)
                        
                        Text("Loading \(category.title)…")
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if let errorMessage {
                    ContentUnavailableView(
                        "Unable to Load",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                    .foregroundStyle(.white)
                    
                } else if results.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "photo",
                        description: Text(
                            "No NASA media was found for \(category.title)."
                        )
                    )
                    .foregroundStyle(.white)
                    
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(results) { item in
                                NavigationLink {
                                    NASAItemDetailView(item: item)
                                } label: {
                                    NASASearchResultCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            await loadCategory()
        }
    }
    
    @MainActor
    private func loadCategory() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            results = try await mediaService.fetchNASAMedia(
                query: category.searchQuery
            )
        } catch {
            results = []
            errorMessage = error.localizedDescription
        }
    }
}

#Preview("Planets") {
    NavigationStack {
        CategoryDetailView(category: .planets)
    }}
