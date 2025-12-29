//
//  BouquetDesignView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI

struct BouquetDesignView: View {
    @ObservedObject var viewModel: BouquetViewModel
    @State private var showingSendConfirmation = false
    @Environment(\.dismiss) var dismiss
    
    private let maxFlowers = 9
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.92, blue: 0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button (fixed at top)
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("Create Bouquet")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                    
                    Spacer()
                    
                    // Flower counter
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                        Text("\(viewModel.filledSlotsCount)/\(maxFlowers)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                    )
                }
                .padding()
                
                // Flower selection at top - just 3 types
                HStack(spacing: 40) {
                        FlowerAddButton(imageName: "YellowFlower") {
                            if viewModel.canAddMoreFlowers {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.addFlowerToNextSlot(color: .yellow)
                                }
                            }
                        }
                        
                        FlowerAddButton(imageName: "PurpleFlower") {
                            if viewModel.canAddMoreFlowers {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.addFlowerToNextSlot(color: .purple)
                                }
                            }
                        }
                        
                        FlowerAddButton(imageName: "RedFlower") {
                            if viewModel.canAddMoreFlowers {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.addFlowerToNextSlot(color: .red)
                                }
                            }
                        }
                    }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.8))
                )
                .padding(.horizontal)
                
                // Vase area with snap-to flowers
                GeometryReader { geometry in
                    // VASE SIZE - Edit these values:
                    let baseVaseWidth: CGFloat = 650  // ← CHANGE THIS to make vase bigger/smaller
                    let vaseWidth: CGFloat = min(baseVaseWidth, geometry.size.width * 0.95)
                    let scale: CGFloat = vaseWidth / baseVaseWidth // Scale factor for different screens
                    
                    ZStack {
                        // Vase back layer - scales to screen, maintains original aspect ratio
                        Image("CustomVase")
                            .resizable()
                            .scaledToFit()
                            .frame(width: vaseWidth)
                            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            .zIndex(0)
                        
                        // Render flower heads at their positions (no drawn stems)
                        ForEach(viewModel.flowerSlots) { slot in
                            let position = StemPosition.allPositions[slot.id]
                            
                            // Show flower head if slot is filled
                            if let flowerColor = slot.flowerColor {
                                FlowerHeadView(
                                    color: flowerColor, 
                                    rotation: position.rotation,
                                    mirrored: position.mirrored,
                                    size: position.size  // Individual size per flower
                                )
                                .offset(x: position.x * scale, y: position.y * scale) // Scale coordinates
                                .zIndex(Double(20 + slot.id)) // Flowers above vase
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.removeFlowerFromSlot(slotId: slot.id)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + 25)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            
            // Send button - fixed at bottom, overlays everything
            if viewModel.filledSlotsCount > 1 {
                VStack {
                    Spacer()
                    Button(action: {
                        showingSendConfirmation = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 20))
                            Text("Send Bouquet")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.89, green: 0.36, blue: 0.38), Color(red: 0.95, green: 0.55, blue: 0.57)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .alert("Send Bouquet?", isPresented: $showingSendConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Send") {
                viewModel.sendBouquet()
                dismiss()
            }
        } message: {
            Text("This beautiful bouquet will last 24 hours!")
        }
    }
}

struct FlowerAddButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                )
        }
    }
}

struct FlowerTypeButton: View {
    let type: FlowerType
    let color: FlowerColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                SimpleFlowerView(type: type, color: color, size: 50)
                Text(type.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(width: 80, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

// Flower head view that snaps to stem positions
struct FlowerHeadView: View {
    let color: FlowerColor
    let rotation: Double
    let mirrored: Bool
    let size: CGFloat  // Individual size for this flower
    
    var imageName: String {
        switch color {
        case .yellow: return "YellowFlower"
        case .purple: return "PurpleFlower"
        case .red: return "RedFlower"
        default: return "RedFlower"
        }
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .scaleEffect(x: mirrored ? -1 : 1, y: 1) // Horizontal flip for variety
            .rotationEffect(.degrees(rotation)) // Natural rotation variation
    }
}

struct VaseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Polygonal vase shape
        path.move(to: CGPoint(x: width * 0.3, y: 0))
        path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.3))
        path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.7))
        path.addLine(to: CGPoint(x: width * 0.2, y: height))
        path.addLine(to: CGPoint(x: width * 0.8, y: height))
        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.7))
        path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.3))
        path.addLine(to: CGPoint(x: width * 0.7, y: 0))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    // Preview with some flowers pre-loaded for faster testing
    let viewModel = BouquetViewModel()
    viewModel.addFlowerToNextSlot(color: .yellow)
    viewModel.addFlowerToNextSlot(color: .purple)
    viewModel.addFlowerToNextSlot(color: .red)
    viewModel.addFlowerToNextSlot(color: .yellow)
    viewModel.addFlowerToNextSlot(color: .purple)
    viewModel.addFlowerToNextSlot(color: .red)
    
    return BouquetDesignView(viewModel: viewModel)
}

