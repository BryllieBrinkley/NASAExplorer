//
//  RootTabSwift.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/25/26.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            Tab("Today", image: "calendar") {
                TodayView()
            }
            
            Tab("Explore", image: "map.fill") {
                ExploreView()
            }
            
            
            Tab("Asteroids", image: "circle.dotted.circle") {
                AsteroidListView()
            }
            
            Tab("Saved", image: "bookmark") {
                SavedView()
            }
            
            
        }
    }
}

#Preview {
    RootTabView()
}
