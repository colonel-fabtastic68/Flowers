//
//  BouquetDisplayView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI
import Combine

struct BouquetDisplayView: View {
    let bouquet: Bouquet
    @State private var timeRemaining: TimeInterval
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(bouquet: Bouquet) {
        self.bouquet = bouquet
        _timeRemaining = State(initialValue: bouquet.timeRemaining)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.92, blue: 0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Timer
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                        Text(timeString(from: timeRemaining))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                        Text("remaining")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange, Color.red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * (timeRemaining / (24 * 3600)))
                        }
                    }
                    .frame(height: 8)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.8))
                )
                .padding(.horizontal)
                
                // Bouquet display
                ZStack {
                    // Custom vase image
                    Image("CustomVase")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 220)
                        .offset(y: 120)
                        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                    
                    ForEach(bouquet.flowers) { flower in
                        SimpleFlowerView(type: flower.type, color: flower.color, size: 60 * flower.scale)
                            .rotationEffect(.degrees(flower.rotation))
                            .offset(x: flower.xPosition, y: flower.yPosition - 30)
                    }
                }
                .frame(height: 450)
                .padding()
                
                Spacer()
                
                Text("Long press a flower to rearrange")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
        }
        .onReceive(timer) { _ in
            timeRemaining = bouquet.timeRemaining
        }
    }
    
    private func timeString(from interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    let flowers = [
        Flower(type: .tulip, color: .pink, xPosition: -60, yPosition: -100, rotation: -15),
        Flower(type: .rose, color: .peach, xPosition: 0, yPosition: -120, rotation: 0),
        Flower(type: .lily, color: .white, xPosition: 50, yPosition: -80, rotation: 10),
        Flower(type: .iris, color: .purple, xPosition: 70, yPosition: -50, rotation: 20)
    ]
    let bouquet = Bouquet(flowers: flowers, fromUserId: "1", toUserId: "2")
    return BouquetDisplayView(bouquet: bouquet)
}

