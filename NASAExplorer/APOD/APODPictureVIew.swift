//
//  APODPictureVIew.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/28/26.
//

import SwiftUI

struct APODPictureView: View {
    let pictureOfDay: PictureOfDay?
    let isLoading: Bool

    @Binding var expandPic: Bool

    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading official NASA images and videos....")
                    .tint(.white)
                    .foregroundStyle(.white)
                    .frame(height: 300)
            } else if let pictureOfDay {
                if pictureOfDay.mediaType == "image" {
                    imageSection(picture: pictureOfDay)
                } else if pictureOfDay.mediaType == "video" {
                    videoSection(picture: pictureOfDay)
                } else {
                    imagePlaceholder
                }
            }
        }
    }
   
    private var imagePlaceholder: some View {
            Image(.nasaLogo)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }

    private func imageSection(picture: PictureOfDay) -> some View {
        ZStack(alignment: .topTrailing) {
            
            AsyncImage(url: picture.pictureURL) { phase in
                switch phase { 
                case .empty:
                    ProgressView()
                        .tint(.white)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
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
            .frame(height: 250)
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
        .sheet(isPresented: $expandPic) {
            ExpandedAPODView(imageURL: picture.pictureURL)
        }
    }
    
    private func videoSection(picture: PictureOfDay) -> some View {
                        ContentUnavailableView {
                            Label("Video of the Day", systemImage: "play.rectangle")
                        } description: {
                            Text("This APOD is a video. Video support will be added next.")
                        } actions: {
                            Link("Open NASA Video", destination: picture.pictureURL)
                        }
                        .foregroundStyle(.white)
                        .frame(height: 300)
                    }


}


#Preview {
    APODPictureView(
        pictureOfDay: PictureOfDay(
            copyright: "NASA",
            explanation: "Preview description",
            pictureURL: URL(string: "https://apod.nasa.gov/apod/image/2501/example.jpg")!,
            title: "NASA Picture",
            mediaType: "image"
        ),
        isLoading: false,
        expandPic: .constant(false)
    )
}
