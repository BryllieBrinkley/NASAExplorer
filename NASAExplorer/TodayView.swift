import SwiftUI

struct TodayView: View {
    @State private var pictureOfDay: PictureOfDay?

    var body: some View {
        ZStack {
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                ZStack {
                    VStack {
                        LinearGradient(
                            colors: [
                                .orange,
                                .gray,
                                .orange
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("Image of the day")
                                .font(.largeTitle)
                                .fontWeight(.light)
                        )
                        
                        
                        ZStack {
                            AsyncImage(url: URL(string: pictureOfDay?.pictureUrl ?? ""), content: { image in
                                image
                            }, placeholder: {
                                Image(.nasaLogo)
                                    .resizable()
                                    .scaledToFit()
                            })
                            
                                
                                .frame(width: 200, height: 200)
                                .overlay {
                                    Button {
                                        print("expand apod")
                                    } label: {
                                        Image(systemName: "rectangle.expand.diagonal")
                                            .background(.black.opacity(0.4))
                                            .frame(width: 200, height: 200)
                                    }
                                    
                                    
                                }
                        }
                        
                        Text(pictureOfDay?.title ?? "Placeholder for the image description of the APOD from NASA")
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        
                        Spacer()
                        
                        
                    }
                    }
                .task {
                    do {
                        pictureOfDay = try await getPicture()
                    } catch APIError.invalidURL {
                        print("invalidURL")
                    } catch APIError.invalidResponse {
                        print("invalidResponse")
                    } catch APIError.invalidData {
                        print("invalidData")
                    } catch {
                        print("Unexpected Error")
                    }
                }
                }

        }
    }

}

struct PictureOfDay: Decodable {
    let copyright: String
    let explanation: String
    let pictureUrl: String
    let title: String
}
    
func getPicture() async throws -> PictureOfDay {
        
        let endpoint = "https://api.nasa.gov/planetary/apod?api_key="
        
        guard let url = URL(string: endpoint) else {
            
            throw APIError.invalidURL
            
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PictureOfDay.self, from: data)
        } catch {
            throw APIError.invalidData
        }
       
}

#Preview {
    TodayView()
}


