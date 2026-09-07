import SwiftUI

struct SavedNASAItemCard: View {

    let item: SavedNASAItem

    var body: some View {

        HStack(spacing: 14) {

            if let imageURL = item.imageURL,
               let url = URL(string: imageURL) {

                AsyncImage(url: url) { phase in
                    switch phase {

                    case .empty:
                        ProgressView()

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        imagePlaceholder

                    @unknown default:
                        imagePlaceholder
                    }
                }
                .frame(width: 110, height: 100)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

            } else {

                imagePlaceholder
                    .frame(width: 110, height: 100)
            }

            VStack(alignment: .leading, spacing: 8) {

                Text(item.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                if let description = item.itemDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(3)
                }

                HStack {
                    if let mediaType = item.mediaType {
                        Text(mediaType.capitalized)
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Image(systemName: "bookmark.fill")
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    AppColors.nasaRed.opacity(0.7),
                    AppColors.surface,
                    AppColors.starGold.opacity(0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(
                AppColors.nasaRed.opacity(0.5),
                lineWidth: 1
            )
        }
        .shadow(
            color: .orange,
            radius: 10,
            x: 0,
            y: 6
        )
    }

    private var imagePlaceholder: some View {

        ZStack {
            AppColors.surface

            Image(systemName: "photo")
                .font(.title)
                .foregroundStyle(AppColors.secondaryText)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {

    ZStack {

        AppBackground()

        SavedNASAItemCard(
            item: SavedNASAItem(
                nasaID: "1234",
                title: "Dummy Data",
                itemDescription: "This is a placeholder for a description. Just working on SwiftUI skills.",
                mediaType: "image",
                imageURL: nil,
                dateCreated: "09/03/2026"
            )
        )
        .padding(20)
    }
}
