
import SwiftUI

struct NASAItemDetailView: View {
    let item: NASAItem

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncImage(url: item.previewURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(item.details?.title ?? "Untitled")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.primaryText)

                    Text(item.details?.description ?? "No description available.")
                        .foregroundStyle(AppColors.secondaryText)

                    if let nasaID = item.details?.nasaId {
                        Text("NASA ID: \(nasaID)")
                            .font(.caption)
                            .foregroundStyle(AppColors.tertiaryText)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("NASA Media")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}


//#Preview {
////    NASAItemDetailView(item: )
//}
