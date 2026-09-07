//
//  AppBAckground.swift
//  NASAExplorer
//
//  Created by Jibryll Brinkley on 8/31/26.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            AppColors.spaceGradient
            StarField()
        }
        .ignoresSafeArea()
    }
}

struct StarField: View {
    let starCount = 120

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<starCount, id: \.self) { _ in
                    Image(systemName: "sparkle")
                        .font(.system(size: CGFloat.random(in: 4...10)))
                        .foregroundStyle(.white.opacity(0.7))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    AppBackground()
}
