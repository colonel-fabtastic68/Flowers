//
//  FlowerWithStemView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI

struct FlowerWithStemView: View {
    let flower: Flower
    let anchorPoint: CGPoint // Where stem connects to vase
    let flowerPosition: CGPoint // Where flower head is
    
    var body: some View {
        ZStack {
            // Draw stem from anchor to flower
            Path { path in
                path.move(to: anchorPoint)
                path.addLine(to: flowerPosition)
            }
            .stroke(Color(red: 0.45, green: 0.65, blue: 0.45), lineWidth: 4)
            
            // Flower head at position
            SimpleFlowerView(type: flower.type, color: flower.color, size: 75)
                .position(flowerPosition)
        }
    }
}

