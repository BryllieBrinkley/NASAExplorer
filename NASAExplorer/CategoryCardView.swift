import SwiftUI

struct CategoryCardView: View {
    let category: ContentCategory

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 175, height: 175)
                .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.85)
                ],
                startPoint: .center,
                endPoint: .bottom
            )

            Text(category.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.primaryText)
                .multilineTextAlignment(.leading)
                .padding()
        }
        .frame(width: 175, height: 175)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.border, lineWidth: 1)
        }
    }
}

#Preview {
    CategoryCardView(category: .planets)
        .padding()
        .background(AppColors.background)
}
