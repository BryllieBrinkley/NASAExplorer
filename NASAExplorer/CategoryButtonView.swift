//
//  CategoryButtonView.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/26/26.
//

import SwiftUI

struct CategoryButtonView: View {
    
    let categories: [Category] = [
        Category(name: "Planets", imageName: "planets-card-bg"),
        Category(name: "Missions", imageName: "missions-card-bg"),
        Category(name: "NASA Official Images", imageName: "nasa-images-card-bg"),
        Category(name: "Asteroids", imageName: "asteroid-card-bg")
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(categories) { category in

                Button {
                    
                    //logic for each category
                    print("\(category.name) pressed")
                    
                } label: {
                    ZStack(alignment: .center) {
                        VStack(alignment: .center, spacing: 20) {
                            Image(category.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .clipShape(.rect(cornerRadius: 20))
                                .padding()
                                .overlay {
                                    Text(category.name)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .padding(.top, 84)
                                        .multilineTextAlignment(.center)
                                }
                            
                        }
                    }
                }
                       
            }
        }
    }
}


struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
}

#Preview {
    CategoryButtonView()
}
