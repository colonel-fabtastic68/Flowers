//
//  User.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String // Unique UUID
    var code: String // 4-digit code (e.g. "1234")
    var name: String
    var partnerId: String?
    var streakCount: Int = 0
    var lastBouquetSent: Date?
    
    var hasPartner: Bool {
        partnerId != nil
    }
    
    // Generate random 4-digit code
    static func generateCode() -> String {
        let code = Int.random(in: 0...9999)
        return String(format: "%04d", code)
    }
}

