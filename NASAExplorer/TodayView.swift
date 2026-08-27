import SwiftUI

struct TodayView: View {
    
    @State private var pictureOfDay: PictureOfDay?
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var expandPic: Bool = false
    
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    LinearGradient(
                        colors: [.orange, .gray, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask {
                        Text("ASTRONOMY PICTURE OF THE DAY")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .frame(height: 50)

                    pictureSection

                    if let pictureOfDay {
                        Text(pictureOfDay.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        Text(pictureOfDay.explanation)
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.leading)

                        if let copyright = pictureOfDay.copyright {
                            Text("© \(copyright)")
                                .frame(alignment: .leading)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineLimit(2)
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.callout)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)

                        Button("Try Again") {
                            Task {
                                await loadPicture()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
        }.fullScreenCover(isPresented: $expandPic, content: {
            ExpandedAPODView(imageURL: pictureOfDay?.pictureURL ?? imagePlaceholder as! URL)
        })
        .task {
            await loadPicture()
        }
    }

    @ViewBuilder
    private var pictureSection: some View {
        if isLoading {
            ProgressView("Loading NASA image…")
                .tint(.white)
                .foregroundStyle(.white)
                .frame(height: 300)
        } else if let pictureOfDay {
            if pictureOfDay.mediaType == "image" {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: pictureOfDay.pictureURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.white)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    expandPic = true
                                }

                        case .failure:
                            imagePlaceholder

                        @unknown default:
                            imagePlaceholder
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(.gray.opacity(0.2))
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )

                    Button {
                        expandPic = true
                        
                    } label: {
                        Image(systemName: "rectangle.expand.diagonal")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(12)
                }
            } else {
                ContentUnavailableView {
                    Label("Video of the Day", systemImage: "play.rectangle")
                } description: {
                    Text("This APOD is a video. Video support will be added next.")
                } actions: {
                    Link("Open NASA Video", destination: pictureOfDay.pictureURL)
                }
                .foregroundStyle(.white)
                .frame(height: 300)
            }
        } else {
            imagePlaceholder
        }
    }

    private var imagePlaceholder: some View {
        Image(.nasaLogo)
            .resizable()
            .scaledToFit()
            .frame(height: 200)
    }

    @MainActor
    private func loadPicture() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            pictureOfDay = try await getPicture()
        } catch APIError.invalidURL {
            errorMessage = "The NASA URL could not be created."
        } catch APIError.invalidResponse {
            errorMessage = "NASA returned an invalid response."
        } catch APIError.invalidData {
            errorMessage = "The NASA data could not be decoded."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct PictureOfDay: Decodable {
    let copyright: String?
    let explanation: String
    let pictureURL: URL
    let title: String
    let mediaType: String

    enum CodingKeys: String, CodingKey {
        case copyright
        case explanation
        case title
        case pictureURL = "url"
        case mediaType = "media_type"
    }
}

func getPicture() async throws -> PictureOfDay {
    let apiKey = try AppConfiguration.nasaAPIKey

    var components = URLComponents(
        string: "https://api.nasa.gov/planetary/apod"
    )

    components?.queryItems = [
        URLQueryItem(
            name: "api_key",
            value: apiKey
        )
    ]

    guard let url = components?.url else {
        throw APIError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw APIError.invalidResponse
    }

    do {
        return try JSONDecoder().decode(
            PictureOfDay.self,
            from: data
        )
    } catch {
        print("Decoding error:", error)
        throw APIError.invalidData
    }
}

#Preview {
    TodayView()
}
