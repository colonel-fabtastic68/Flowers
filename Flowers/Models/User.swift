//
//  User.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var partnerId: String?
    var streakCount: Int = 0
    var lastBouquetSent: Date?
    
    var hasPartner: Bool {
        partnerId != nil
    }
}

