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
                        .padding()
                    }
                }
            }
            .navigationTitle("Results for \(query)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("NASAResultsView") {
    let viewModel = ExploreViewModel(
        mediaService: NASAMediaService()
    )
}
