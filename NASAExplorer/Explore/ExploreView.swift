import SwiftUI
import SwiftData

struct ExploreView: View {
    @State private var searchText = ""
    @State private var submittedQuery = ""
    @State private var showSearchSheet = false
    @State private var viewModel = ExploreViewModel(
        mediaService: NASAMediaService()
    )
    
    @State private var pictureOfDay: PictureOfDay?
    @State private var isLoading = false
    @State private var expandPic: Bool = false
    @State private var imagePlaceholder = Image(.nasaLogo)
    @FocusState private var isSearchFocused: Bool
    @Binding var shouldFocusSearch: Bool
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \SavedNASAItem.dateCreated, order: .reverse)
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
            do {
                pictureOfDay = try await getPicture()
            } catch {
                print(APIError.invalidResponse)
            }
            isLoading = false
            
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
            Button {
                print("tapped category")
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
                pictureOfDay: pictureOfDay,
                isLoading: isLoading,
                expandPic: $expandPic)
        }
    }
    
    private var recentlySaved: some View {
        VStack {
            HStack {
                Text("Recently Saved")
                    .font(.largeTitle)
                    .foregroundStyle(AppColors.primaryText)
                
                Spacer()
                
                NavigationLink(destination: SavedView()) {
                        Text("See All")
                            .foregroundStyle(.primary)
                            .underline()
                }
            }
            
            
            ForEach(savedItems) { item in
                SavedNASAItemCard(item: item)
                
                
            }
        }
        
    }
}

#Preview {
    ExploreView(shouldFocusSearch: .constant(false))
}
