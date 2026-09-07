//
//  FeaturedView.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/26/26.
//

import SwiftUI

struct FeaturedView: View {

    var body: some View {
        NavigationStack {
                ZStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                        Text("Featured")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(1..<10) {_ in
                                    FeaturedTopicCard(imageName: "voyager1", imageDesc: "Beyond the Solar System")
                                    FeaturedTopicCard(imageName: "jameswebb", imageDesc: "Early Space Exploration")

                                }
                                .padding()
                                
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.black)
                                    .padding()

                            }
                            
                        }
                    }
                }
                    .padding()
            }
        }
    }
}

struct FeaturedTopic {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

struct FeaturedTopicCard: View {
    var imageName: String
    var imageDesc: String
    var body: some View {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 175)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding()
                
                Text(imageDesc)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
        }
    }
}







#Preview {
    FeaturedView()
}
