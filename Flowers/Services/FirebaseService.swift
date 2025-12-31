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
            "code": user.code,
            "name": user.name,
            "partnerId": user.partnerId ?? "",
            "streakCount": user.streakCount,
            "lastBouquetSent": user.lastBouquetSent?.timeIntervalSince1970 ?? 0
        ]
        
        try await db.collection("users").document(user.id).setData(userData)
        
        // Also save to codes collection for lookup (code -> userId mapping)
        try await db.collection("codes").document(user.code).setData([
            "userId": user.id,
            "createdAt": Date().timeIntervalSince1970
        ])
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
            code: data["code"] as? String ?? "0000",
            name: data["name"] as? String ?? "User",
            partnerId: data["partnerId"] as? String,
            streakCount: data["streakCount"] as? Int ?? 0,
            lastBouquetSent: lastBouquetSent
        )
    }
    
    // Look up user by their 4-digit code
    func getUserByCode(_ code: String) async throws -> User? {
        // First, find the userId from the codes collection
        let codeDoc = try await db.collection("codes").document(code).getDocument()
        
        guard let codeData = codeDoc.data(),
              let userId = codeData["userId"] as? String else {
            return nil
        }
        
        // Then fetch the full user data
        return try await getUser(userId: userId)
    }
    
    // Check if a code is available
    func isCodeAvailable(_ code: String) async throws -> Bool {
        let doc = try await db.collection("codes").document(code).getDocument()
        return !doc.exists
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
    
}

