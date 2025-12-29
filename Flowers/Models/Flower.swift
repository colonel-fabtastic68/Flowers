//
//  Flower.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI

enum FlowerType: String, CaseIterable, Codable {
    case tulip = "Tulip"
    case rose = "Rose"
    case daisy = "Daisy"
    case lily = "Lily"
    case iris = "Iris"
    case sunflower = "Sunflower"
    
    var emoji: String {
        switch self {
        case .tulip: return "🌷"
        case .rose: return "🌹"
        case .daisy: return "🌼"
        case .lily: return "🌸"
        case .iris: return "🪻"
        case .sunflower: return "🌻"
        }
    }
}

enum FlowerColor: String, CaseIterable, Codable {
    case pink = "Pink"
    case peach = "Peach"
    case purple = "Purple"
    case yellow = "Yellow"
    case white = "White"
    case red = "Red"
    
    var color: Color {
        switch self {
        case .pink: return Color(red: 0.95, green: 0.75, blue: 0.79)
        case .peach: return Color(red: 0.98, green: 0.81, blue: 0.69)
        case .purple: return Color(red: 0.73, green: 0.68, blue: 0.84)
        case .yellow: return Color(red: 0.98, green: 0.93, blue: 0.57)
        case .white: return Color(red: 0.97, green: 0.96, blue: 0.92)
        case .red: return Color(red: 0.89, green: 0.36, blue: 0.38)
        }
    }
}

struct Flower: Identifiable, Codable, Equatable {
    var id = UUID()
    var type: FlowerType
    var color: FlowerColor
    var xPosition: Double
    var yPosition: Double
    var rotation: Double
    var scale: Double
    
    init(type: FlowerType, color: FlowerColor, xPosition: Double = 0, yPosition: Double = 0, rotation: Double = 0, scale: Double = 1.0) {
        self.type = type
        self.color = color
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.rotation = rotation
        self.scale = scale
    }
}

// Predefined stem positions in the vase
struct StemPosition {
    let id: Int
    let x: Double
    let y: Double
    let rotation: Double
    let mirrored: Bool  // Horizontal flip for variety
    
    static let allPositions: [StemPosition] = [
        // Row 1 (back) - 3 stems with varied rotation
        StemPosition(id: 0, x: -50, y: -110, rotation: -7, mirrored: false),
        StemPosition(id: 1, x: 0, y: -115, rotation: 3, mirrored: true),
        StemPosition(id: 2, x: 50, y: -110, rotation: 9, mirrored: false),
        
        // Row 2 (middle) - 3 stems with varied rotation
        StemPosition(id: 3, x: -40, y: -85, rotation: -4, mirrored: true),
        StemPosition(id: 4, x: 0, y: -90, rotation: -2, mirrored: false),
        StemPosition(id: 5, x: 40, y: -85, rotation: 6, mirrored: false),
        
        // Row 3 (front) - 3 stems with varied rotation
        StemPosition(id: 6, x: -30, y: -60, rotation: -5, mirrored: false),
        StemPosition(id: 7, x: 0, y: -65, rotation: 2, mirrored: true),
        StemPosition(id: 8, x: 30, y: -60, rotation: 8, mirrored: false)
    ]
}

// Slot-based flower system for easy saving/sharing
struct FlowerSlot: Identifiable, Codable {
    let id: Int // matches StemPosition.id
    var flowerColor: FlowerColor? // nil = empty slot
    
    init(id: Int, flowerColor: FlowerColor? = nil) {
        self.id = id
        self.flowerColor = flowerColor
    }
}

