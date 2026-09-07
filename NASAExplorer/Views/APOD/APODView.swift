import SwiftUI

struct APODView: View {
    @StateObject private var viewModel = APODViewModel()
    
    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(spacing: 20) {

                    Text("ASTRONOMY PICTURE OF THE DAY")
                        .font(.system(size: 35))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(AppColors.starGold)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)

                    APODPictureView(
                        pictureOfDay: viewModel.picture,
                        isLoading: viewModel.isLoading,
                        expandPic: $viewModel.isExpanded
                    )

                    if let pictureOfDay = viewModel.picture {
                        Text(pictureOfDay.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(pictureOfDay.explanation)
                            .font(.body)
                            .foregroundStyle(AppColors.secondaryText)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if let copyright = pictureOfDay.copyright {
                            let cleanedCopyright = copyright
                                .replacingOccurrences(of: "\n", with: " ")

                            Text("© \(cleanedCopyright)")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.nasaGradient)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)
                .padding(.bottom, 120)
            }
            
        }.fullScreenCover(isPresented: $viewModel.isExpanded, content: {
            if let url = viewModel.picture?.pictureURL {
                ExpandedAPODView(imageURL: url)
            }
        })
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    APODView()
}
