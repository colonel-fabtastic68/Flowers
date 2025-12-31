//
//  FirebaseService.swift
//  Flowers
//
//  Created by Baker Cobb on 12/30/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - User Operations
    
    func saveUser(_ user: User) async throws {
        let userData: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "partnerId": user.partnerId ?? "",
            "streakCount": user.streakCount,
            "lastBouquetSent": user.lastBouquetSent?.timeIntervalSince1970 ?? 0
        ]
        
        try await db.collection("users").document(user.id).setData(userData)
    }
    
    func getUser(userId: String) async throws -> User? {
        let document = try await db.collection("users").document(userId).getDocument()
        
        guard let data = document.data() else { return nil }
        
        let lastBouquetTimestamp = data["lastBouquetSent"] as? TimeInterval
        let lastBouquetSent = lastBouquetTimestamp != nil && lastBouquetTimestamp! > 0 
            ? Date(timeIntervalSince1970: lastBouquetTimestamp!) 
            : nil
        
        return User(
            id: data["id"] as? String ?? userId,
            name: data["name"] as? String ?? "User",
            partnerId: data["partnerId"] as? String,
            streakCount: data["streakCount"] as? Int ?? 0,
            lastBouquetSent: lastBouquetSent
        )
    }
    
    // MARK: - Bouquet Operations
    
    func sendBouquet(_ bouquet: Bouquet) async throws {
        let bouquetData = try JSONEncoder().encode(bouquet)
        let bouquetDict = try JSONSerialization.jsonObject(with: bouquetData) as? [String: Any] ?? [:]
        
        try await db.collection("bouquets").document(bouquet.id.uuidString).setData(bouquetDict)
        
        // Also save to recipient's received bouquets
        try await db.collection("users")
            .document(bouquet.toUserId)
            .collection("receivedBouquets")
            .document(bouquet.id.uuidString)
            .setData(bouquetDict)
    }
    
    func getReceivedBouquets(userId: String) async throws -> [Bouquet] {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("receivedBouquets")
            .order(by: "dateSent", descending: true)
            .getDocuments()
        
        var bouquets: [Bouquet] = []
        
        for document in snapshot.documents {
            if let jsonData = try? JSONSerialization.data(withJSONObject: document.data()),
               let bouquet = try? JSONDecoder().decode(Bouquet.self, from: jsonData) {
                if !bouquet.isExpired {
                    bouquets.append(bouquet)
                }
            }
        }
        
        return bouquets
    }
    
    func getActiveBouquet(userId: String) async throws -> Bouquet? {
        let bouquets = try await getReceivedBouquets(userId: userId)
        return bouquets.first
    }
    
    // MARK: - Pairing Operations
    
    func pairUsers(userId: String, partnerId: String) async throws {
        // Update both users' partner IDs
        try await db.collection("users").document(userId).updateData([
            "partnerId": partnerId
        ])
        
        try await db.collection("users").document(partnerId).updateData([
            "partnerId": userId
        ])
    }
    
    // MARK: - Testing & Debugging
    
    func testConnection() async throws -> Bool {
        // Try to write a test document
        let testData: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "message": "Firebase connection test successful! 🎉"
        ]
        
        try await db.collection("_test").document("connection").setData(testData)
        
        // Try to read it back
        let doc = try await db.collection("_test").document("connection").getDocument()
        
        return doc.exists
    }
    
    func saveTestBouquet(slots: [FlowerSlot], userId: String) async throws {
        let testData: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "userId": userId,
            "flowerCount": slots.filter { $0.flowerColor != nil }.count,
            "slots": slots.filter { $0.flowerColor != nil }.map { slot in
                [
                    "id": slot.id,
                    "color": slot.flowerColor?.rawValue ?? "",
                    "rotation": slot.rotation ?? 0,
                    "mirrored": slot.mirrored ?? false
                ]
            }
        ]
        
        try await db.collection("test_bouquets").document(UUID().uuidString).setData(testData)
        print("✅ Test bouquet saved to Firebase!")
        print("📊 Data: \(testData)")
    }
}

