import SwiftUI

struct RootTabView: View {

    @State private var selectedTab: AppTab = .explore

    var body: some View {

        ZStack(alignment: .bottom) {

            // MARK: - Current Screen
            Group {

                switch selectedTab {

                case .explore:
                    ExploreView()
                case .today:
                    APODView()
                case .saved:
                    SavedView()
                case .search:
                    SearchView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // MARK: - Custom Tab Bar

            HStack(spacing: 12) {

                // Main grouped tabs
                HStack(spacing: 4) {

                    tabButton(
                        tab: .today,
                        icon: "calendar",
                        title: "APOD"
                    )

                    tabButton(
                        tab: .explore,
                        icon: "map.fill",
                        title: "Explore"
                    )
                    tabButton(
                        tab: .saved,
                        icon: "bookmark.fill",
                        title: "Saved"
                    )
                }
                .padding(6)
                .background(.thickMaterial)
                .foregroundStyle(AppColors.nasaBlue)
                .clipShape(Capsule())

                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = .saved
                    }
                } label: {
                    tabButton(
                        tab: .explore,
                        icon: "magnifyingglass",
                        title: "Search"
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }


    // MARK: - Tab Button

    private func tabButton(
        tab: AppTab,
        icon: String,
        title: String
    ) -> some View {

        Button {

            withAnimation(.spring(response: 0.3)) {
                selectedTab = tab
            }

        } label: {

            VStack(spacing: 3) {

                Image(systemName: icon)
                    .font(.system(size: 19, weight: .semibold))

                Text(title)
                    .font(.caption2)
            }
            .foregroundStyle(
                selectedTab == tab
                ? .primary
                : .secondary
            )
            .frame(width: 72, height: 48)
        }
    }
}

#Preview {
    RootTabView()
}
