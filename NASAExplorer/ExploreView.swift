import SwiftUI

struct ExploreView: View {
    
    @State private var searchText: String = ""
    @State private var showSearchSheet = false
    @State private var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack(spacing: 20) {
                        
                        TextField("Search NASA", text: $searchText)
                            .submitLabel(.search)
                            .onSubmit {
                                let query = searchText.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )

                                guard !query.isEmpty else {
                                    return
                                }

                                showSearchSheet = true

                                Task {
                                    await viewModel.searchNASAMedia(query: query)
                                }
                            }
                            .padding()
                            .background(.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    
                    
                    Text("Browse")
                        .font(.title)
                        .fontWeight(.light)
                    
                    CategoryButtonView()
                    FeaturedView()
                }
                .padding()
            }
            .navigationTitle("Explore")
            .foregroundStyle(.black)
            .sheet(isPresented: $showSearchSheet) {
                NASAResultsView(
                    query: searchText,
                    viewModel: viewModel
                )
                .presentationDetents([.medium, .large])
            }
            
        }
        
    }
}

enum ContentCategories {
    case Planets, Missions, Spacecraft, Asteroids, NASAImageLibrary
}

struct NASASearchResponse: Decodable {
    let collection: NASACollection
}

struct NASACollection: Decodable {
    let items: [NASAItem]
}

struct NASAImageData: Decodable {
    let center: String?
    let dateCreated: String?
    let description: String?
    let keywords: [String]?
    let location: String?
    let mediaType: String?
    let nasaId: String?
    let photographer: String?
    let title: String?
}

struct NASAItem: Decodable, Identifiable {
    let data: [NASAImageData]
    let links: [NASAImageLink]?
    
    var id: String {
        data.first?.nasaId ?? links?.first?.href ?? "unknown"
    }
    
    var previewURL: URL? {
        guard let href = links?.first?.href else {
            return nil
        }
        
        return URL(string: href)
    }
}

struct NASAImageLink: Decodable {
    let href: String
    let rel: String?
    let render: String?
}

#Preview {
    ExploreView()
}
