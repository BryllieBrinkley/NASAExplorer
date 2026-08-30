import SwiftUI

struct APODView: View {
    @State private var pictureOfDay: PictureOfDay?
    @State private var isLoading = false
    @State private var expandPic = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            AppColors.spaceGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text("ASTRONOMY PICTURE OF THE DAY")
                        .font(.system(size: 35))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(AppColors.starGold)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    
                    
                    APODPictureView(
                        pictureOfDay: pictureOfDay,
                        isLoading: isLoading,
                        expandPic: $expandPic
                    )
                    
                
                    if let pictureOfDay {
                        Text(pictureOfDay.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primaryText)
                            .padding()
                        
                        Text(pictureOfDay.explanation)
                            .font(.body)
                            .foregroundStyle(AppColors.secondaryText)
                            .multilineTextAlignment(.leading)
                            .padding()
                        
                        if let copyright = pictureOfDay.copyright {
                            Text("© \(copyright)")
                                .frame(alignment: .leading)
                                .font(.subheadline)
                                .foregroundStyle(AppColors.nasaGradient)
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
            if let url = pictureOfDay?.pictureURL {
                ExpandedAPODView(imageURL: url)
            }
        })
        .task {
            await loadPicture()
        }
    }
    
    @MainActor
    private func loadPicture() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let picture = try await getPicture()
            pictureOfDay = picture
            saveAPOD(picture)

        } catch APIError.invalidResponse {

            if let cachedPicture = fetchLastAPOD() {
                pictureOfDay = cachedPicture
                errorMessage = "NASA is temporarily unavailable. Showing the last saved APOD."
            } else {
                errorMessage = "NASA is temporarily unavailable. Please try again later."
            }

        } catch APIError.invalidURL {

            errorMessage = "The NASA URL could not be created."

        } catch APIError.invalidData {

            if let cachedPicture = fetchLastAPOD() {
                pictureOfDay = cachedPicture
                errorMessage = "Could not read NASA's latest data. Showing the last saved APOD."
            } else {
                errorMessage = "The NASA data could not be decoded."
            }

        } catch {

            if let cachedPicture = fetchLastAPOD() {
                pictureOfDay = cachedPicture
                errorMessage = "Unable to reach NASA. Showing the last saved APOD."
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}





//Fetch APOD 
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



// CachedAPOD
private let cachedAPODKey = "cachedAPOD"

func saveAPOD(_ picture: PictureOfDay) {
    do {
        let data = try JSONEncoder().encode(picture)
        UserDefaults.standard.set(data, forKey: cachedAPODKey)
    } catch {
        print("Failed to cache APOD:", error)
    }
}

func fetchLastAPOD() -> PictureOfDay? {

    guard let data = UserDefaults.standard.data(
        forKey: cachedAPODKey
    ) else {
        return nil
    }

    do {
        return try JSONDecoder().decode(
            PictureOfDay.self,
            from: data
        )

    } catch {
        print("Failed to load cached APOD:", error)
        return nil
    }
}

struct PictureOfDay: Codable {
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


#Preview {
    APODView()
}
