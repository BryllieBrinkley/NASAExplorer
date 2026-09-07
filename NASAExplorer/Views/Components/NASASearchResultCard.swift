//
//  NASASearchResultCard.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 9/3/26.
//

import SwiftUI

struct NASASearchResultCard: View {
    let item: NASAItem
    
    @Environment(\.modelContext) private var context
    
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
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text(item.data.first?.title ?? "Untitled")
                    .font(.headline)
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(2)
                
                Text(item.data.first?.description ?? "No description")
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(3)
            }
            
            Spacer()
            
            Button {
                SavedItemsManager.save(
                    item: item,
                    context: context
                )
            } label: {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(AppColors.starGold)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                AppColors.starGold.opacity(0.25),
                lineWidth: 1
            )
        }
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
