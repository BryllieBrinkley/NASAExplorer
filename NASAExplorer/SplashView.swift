//
//  ContentView.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/25/26.
//

import SwiftUI

struct SplashView: View {
    
    @State private var showText: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.spaceGradient
                .ignoresSafeArea(.all)
            VStack(spacing: 25) {
                

                
                Text(showText ? "NASA Space": "")
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.primaryText)
                    .fontWidth(.expanded)
                
                Image(showText ? "nasa-logo" : "moon.fill")
                    .resizable()
                    .scaledToFit()
                    .glassEffect(Glass.regular.tint(AppColors.highlightedBorder.opacity(0.4)))
                
                Text(showText ? "Explorer" : "")
                    .font(.system(size: 80))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.primaryText)
                    .fontWidth(.expanded)
                

            }
            .onAppear(perform: {
                withAnimation(.snappy(duration: 4.0)) {
                    showText = true
                }
            })
        }
        
    }
}

#Preview {
    SplashView()
}
