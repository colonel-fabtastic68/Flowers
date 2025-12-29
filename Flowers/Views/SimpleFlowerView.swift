//
//  SimpleFlowerView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI

struct SimpleFlowerView: View {
    let type: FlowerType
    let color: FlowerColor
    let size: CGFloat
    
    var body: some View {
        // Just the flower head - no stem or leaves
        if let customImageName = customFlowerImageName {
            Image(customImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        } else {
            // Fallback to SF Symbols for combinations without custom images
            ZStack {
                switch type {
                case .tulip:
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(180))
                case .rose:
                    Image(systemName: "circle.hexagongrid.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .daisy:
                    Image(systemName: "circle.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .lily:
                    Image(systemName: "sparkle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .iris:
                    Image(systemName: "circle.hexagonpath.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .sunflower:
                    Image(systemName: "sun.max.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: size, height: size)
            .foregroundColor(color.color)
        }
    }
    
    // Map your custom flower images to flower types and colors
    private var customFlowerImageName: String? {
        switch color {
        case .red:
            return "RedFlower"
        case .purple:
            return "PurpleFlower"
        case .yellow:
            return "YellowFlower"
        case .pink, .peach, .white:
            // Fallback to yellow for unmapped colors
            return "YellowFlower"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            SimpleFlowerView(type: .tulip, color: .pink, size: 60)
            SimpleFlowerView(type: .rose, color: .peach, size: 60)
            SimpleFlowerView(type: .daisy, color: .yellow, size: 60)
        }
        HStack(spacing: 20) {
            SimpleFlowerView(type: .lily, color: .white, size: 60)
            SimpleFlowerView(type: .iris, color: .purple, size: 60)
            SimpleFlowerView(type: .sunflower, color: .red, size: 60)
        }
    }
    .padding()
}
