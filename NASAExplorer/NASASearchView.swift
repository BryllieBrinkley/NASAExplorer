//
//  NASASearchView.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/27/26.
//

import SwiftUI

struct NASAResultsView: View {
    
    let query: String
    let viewModel: ExploreViewModel
    
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
                                NASASearchResultCard(item: item)
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
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text(item.data.first?.title ?? "Untitled")
                    .font(.headline)
                    .lineLimit(2)

                Text(item.data.first?.description ?? "No description")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    NASAResultsView(
           query: "Mars",
           viewModel: ExploreViewModel()
       )
}
