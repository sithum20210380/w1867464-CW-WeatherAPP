//
//  SkeletonView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-18.
//

import SwiftUI

struct SkeletonView: View {
    var body: some View {
        VStack(spacing: 16) {
            
            VStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 30)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 50)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 150)
                .padding(.horizontal)
        }
        .padding(.vertical)
        .shimmer()
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = -0.5
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(gradient: Gradient(colors: [.clear, Color.white.opacity(0.4), .clear]),
                               startPoint: .leading,
                               endPoint: .trailing)
                    .offset(x: phase * 200)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            phase = 1.5
                        }
                    }
            )
            .mask(content)
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
}

