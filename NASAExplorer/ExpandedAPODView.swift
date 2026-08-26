import SwiftUI

struct ExpandedImageView: View {
    let imageURL: URL

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .tint(.white)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()

                case .failure:
                    ContentUnavailableView(
                        "Image Unavailable",
                        systemImage: "photo"
                    )
                    .foregroundStyle(.white)

                @unknown default:
                    EmptyView()
                }
            }

            VStack {
                HStack {
                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}
