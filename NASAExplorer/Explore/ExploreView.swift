import SwiftUI

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
    
    var body: some View {
        NavigationStack {
            ZStack {
             AppBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Explore")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                        searchField
                        browseSection
                        apodSection
                    }
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
        TextField(
            "",
            text: $searchText,
            prompt: Text("Search NASA")
                .foregroundStyle(.gray)
        )
        .foregroundStyle(.black)
        .submitLabel(.search)
        .onSubmit {
            submitSearch()
        }
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
                        .foregroundStyle(AppColors.primaryText)
                    Image(systemName: "arrow.forward.square")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .foregroundStyle(AppColors.primaryText)
                }
                .padding()
                
                
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
        VStack(alignment: .leading, spacing: 25) {
            NavigationLink {
                APODView()
            } label: {
                HStack {
                    Text("Astronomy Picture of the Day")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundStyle(AppColors.primaryText)

                    Spacer()
                    
                    Image(systemName: "arrow.forward.square")
                        .font(.title2)
                        .foregroundStyle(AppColors.primaryText)
    
                }
                .padding()
            }
 
            APODPictureView(
                pictureOfDay: pictureOfDay,
                isLoading: isLoading,
                expandPic: $expandPic)
        }
    }
}

#Preview {
    ExploreView()
}
