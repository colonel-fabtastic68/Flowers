//
//  Bouquet.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import Foundation

struct Bouquet: Identifiable, Codable {
    var id = UUID()
    var flowers: [Flower]
    var flowerSlots: [FlowerSlot] // Store slot data with rotation/mirror
    var createdAt: Date
    var expiresAt: Date
    var fromUserId: String
    var toUserId: String
    var isViewed: Bool = false
    
    var isExpired: Bool {
        Date() > expiresAt
    }
    
    var timeRemaining: TimeInterval {
        max(0, expiresAt.timeIntervalSinceNow)
    }
    
    init(flowers: [Flower], flowerSlots: [FlowerSlot], fromUserId: String, toUserId: String) {
        self.flowers = flowers
        self.flowerSlots = flowerSlots
        self.createdAt = Date()
        self.expiresAt = Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
        self.fromUserId = fromUserId
        self.toUserId = toUserId
    }
    
    // Legacy init for backwards compatibility
    init(flowers: [Flower], fromUserId: String, toUserId: String) {
        self.flowers = flowers
        self.flowerSlots = [] // Empty for legacy bouquets
        self.createdAt = Date()
        self.expiresAt = Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
        self.fromUserId = fromUserId
        self.toUserId = toUserId
    }
}

