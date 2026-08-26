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
            Color
                .gray
                .opacity(0.7)
                .ignoresSafeArea(.all)
            VStack {
                Text(showText ? "NASA Space": "")
                    .font(.system(size: 48))
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                Image(showText ? "nasa-logo" : "moon.fill")
                    .resizable()
                    .scaledToFit()
                Text(showText ? "Explorer" : "")
                    .font(.system(size: 48))
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                
            }
            .onAppear(perform: {
                withAnimation(.spring(duration: 5.0)) {
                    showText = true
                }
            })
        }
        
    }
}

#Preview {
    SplashView()
}
