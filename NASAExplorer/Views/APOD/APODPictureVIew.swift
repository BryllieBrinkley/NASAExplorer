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
                    .frame(height: 220)
            } else if let pictureOfDay {
                let type = pictureOfDay.mediaType?.lowercased() ?? "image"
                if type == "image" {
                    imageSection(picture: pictureOfDay)
                } else if type == "video" {
                    videoSection(picture: pictureOfDay)
                } else {
                    imageSection(picture: pictureOfDay) // default to image if unknown
                }
            }
        }
    }
   
private var imagePlaceholder: some View {
            Image(.nasaLogo)
                .resizable()
                .scaledToFit()
                .frame(height: 220)
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
            .frame(height: 220)
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
        Link(destination: picture.pictureURL) {
            ZStack {
                
                if let thumbnailString = picture.thumbnailURL, !thumbnailString.isEmpty,
                   let thumbnailURL = URL(string: thumbnailString) {
                    
                    AsyncImage(url: thumbnailURL) { phase in
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
                } else {
                            imagePlaceholder
                        }
                        Image(systemName: "play.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }


#Preview {
    APODPictureView(
        pictureOfDay: PictureOfDay(
            copyright: "NASA",
            explanation: "Preview description",
            pictureURL: URL(string: "https://apod.nasa.gov/apod/image/2501/example.jpg")!,
            title: "NASA Picture",
            mediaType: "image",
            thumbnailURL: "https://images-assets.nasa.gov/image/PIA12348/PIA12348~orig.jpg",
        ),
        isLoading: false,
        expandPic: .constant(false)
    )
}

