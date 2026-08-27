import SwiftUI

struct CategoryDetailView: View {
    let category: Category

    @State private var viewModel = ExploreViewModel()
    @State private var results: [NASAItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            Group {
                if isLoading {
                    ProgressView("Loading \(category.name)…")
                        .tint(.white)
                        .foregroundStyle(.white)

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
                            "No NASA media was found for \(category.name)."
                        )
                    )
                    .foregroundStyle(.white)

                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
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
        .navigationTitle(category.name)
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
            results = try await viewModel.fetchNASAMedia(
                query: category.name
            )
        } catch {
            results = []
            errorMessage = error.localizedDescription
        }
    }
}
