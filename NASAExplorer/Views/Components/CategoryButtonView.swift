import SwiftUI


struct CategoryButtonView: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(ContentCategory.allCases) { category in
                    NavigationLink {
                        CategoryDetailView(category: category)
                    } label: {
                        CategoryCardView(category: category)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        CategoryButtonView()
    }
}
