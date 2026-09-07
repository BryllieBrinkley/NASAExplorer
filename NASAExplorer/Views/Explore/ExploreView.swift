import SwiftUI
import SwiftData

struct ExploreView: View {

    @State private var searchText = ""
    @State private var submittedQuery = ""
    @State private var showSearchSheet = false

    @State private var viewModel = ExploreViewModel(
        mediaService: NASAMediaService()
    )

    @StateObject private var apodViewModel = APODViewModel()

    @FocusState private var isSearchFocused: Bool
    @Binding var shouldFocusSearch: Bool

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \SavedNASAItem.savedAt, order: .reverse)
    private var savedItems: [SavedNASAItem]

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 50) {
                        Text("Explore")
                            .foregroundStyle(.white)
                            .font(.largeTitle)

                        searchField
                        browseSection
                        apodSection
                        recentlySaved

                        Spacer()
                    }
                    .foregroundStyle(AppColors.primaryText)
                    .padding()
                }
            }
            .sheet(isPresented: $showSearchSheet) {
                NASAResultsView(
                    query: submittedQuery,
                    viewModel: viewModel
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
                .presentationBackground {
                    AppBackground()
                }
            }
        }
        .task {
            await apodViewModel.load()
        }
    }

    private var searchField: some View {
        TextField("Search NASA", text: $searchText)
            .focused($isSearchFocused)
            .onChange(of: shouldFocusSearch) { _, newValue in
                if newValue {
                    isSearchFocused = true
                    shouldFocusSearch = false
                }
            }
            .onSubmit {
                submitSearch()
            }
            .foregroundStyle(.black)
            .submitLabel(.search)
            .padding()
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.border, lineWidth: 1)
            }
    }

    private var browseSection: some View {
        VStack(alignment: .leading, spacing: 25) {
            NavigationLink {
                CategoryDetailView(
                    category: ContentCategory.allCases.randomElement()
                        ?? ContentCategory.asteroids
                )
            } label: {
                HStack {
                    Text("Browse Media")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Image(systemName: "arrow.forward.square")
                        .font(.title2)
                }
            }

            CategoryButtonView()
        }
    }

    private func submitSearch() {
        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            return
        }

        submittedQuery = query
        showSearchSheet = true

        Task {
            await viewModel.searchNASAMedia(query: query)
        }
    }

    private var apodSection: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                APODView()
            } label: {
                HStack {
                    Text("Astronomy Picture of the Day")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Image(systemName: "arrow.forward.square")
                        .font(.title2)
                }
            }

            APODPictureView(
                pictureOfDay: apodViewModel.picture,
                isLoading: apodViewModel.isLoading,
                expandPic: $apodViewModel.isExpanded
            )
        }
    }

    private var recentlySaved: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recently Saved")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primaryText)

                Spacer()

                NavigationLink {
                    SavedView()
                } label: {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.secondaryText)
                        .underline()
                }
            }

            if savedItems.isEmpty {
                Text("Recently saved NASA media will appear here.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(savedItems.prefix(4)) { item in
                            SavedNASAItemCard(item: item)
                                .frame(width: 300)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView(shouldFocusSearch: .constant(false))
}
