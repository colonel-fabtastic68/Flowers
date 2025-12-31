//
//  BouquetViewModel.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI
import Combine

@MainActor
class BouquetViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var partner: User?
    @Published var currentBouquet: Bouquet?
    @Published var receivedBouquet: Bouquet?
    @Published var designingFlowers: [Flower] = []
    @Published var flowerSlots: [FlowerSlot] = []
    @Published var streakCount: Int = 0
    @Published var showingInvite: Bool = false
    
    private var timer: Timer?
    private let firebaseService = FirebaseService.shared
    
    init() {
        // Try to load existing user from keychain
        if let savedUserId = KeychainHelper.shared.getUserId(),
           let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        } else {
            // Create new user with unique code
            let newUser = User(
                id: UUID().uuidString,
                code: User.generateCode(),
                name: "You"
            )
            self.currentUser = newUser
            KeychainHelper.shared.saveUserId(newUser.id)
        }
        
        // Initialize 9 empty slots
        self.flowerSlots = (0..<9).map { FlowerSlot(id: $0) }
        loadData()
        startTimer()
    }
    
    func loadData() {
        // Load from UserDefaults (local cache)
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        }
        
        if let partnerId = currentUser.partnerId,
           let partnerData = UserDefaults.standard.data(forKey: "partner_\(partnerId)"),
           let partner = try? JSONDecoder().decode(User.self, from: partnerData) {
            self.partner = partner
        }
        
        if let bouquetData = UserDefaults.standard.data(forKey: "receivedBouquet"),
           let bouquet = try? JSONDecoder().decode(Bouquet.self, from: bouquetData) {
            if !bouquet.isExpired {
                self.receivedBouquet = bouquet
            }
        }
        
        streakCount = currentUser.streakCount
        
        // Sync with Firebase
        Task {
            await syncWithFirebase()
        }
    }
    
    func saveData() {
        // Save to UserDefaults (local cache)
        if let userData = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
        
        if let partner = partner,
           let partnerData = try? JSONEncoder().encode(partner) {
            UserDefaults.standard.set(partnerData, forKey: "partner_\(partner.id)")
        }
        
        // Sync to Firebase
        Task {
            try? await firebaseService.saveUser(currentUser)
        }
    }
    
    private func syncWithFirebase() async {
        // Try to fetch latest data from Firebase
        do {
            if let firebaseUser = try await firebaseService.getUser(userId: currentUser.id) {
                self.currentUser = firebaseUser
                self.streakCount = firebaseUser.streakCount
                
                // Update local cache
                if let userData = try? JSONEncoder().encode(firebaseUser) {
                    UserDefaults.standard.set(userData, forKey: "currentUser")
                }
            }
            
            // Fetch partner if exists
            if let partnerId = currentUser.partnerId,
               let firebasePartner = try await firebaseService.getUser(userId: partnerId) {
                self.partner = firebasePartner
            }
            
            // Fetch received bouquets
            if let activeBouquet = try await firebaseService.getActiveBouquet(userId: currentUser.id) {
                self.receivedBouquet = activeBouquet
            }
        } catch {
            // Silently fail - app works offline with UserDefaults cache
        }
    }
    
    func addFlowerToNextSlot(color: FlowerColor) {
        // Find first empty slot
        if let emptyIndex = flowerSlots.firstIndex(where: { $0.flowerColor == nil }) {
            flowerSlots[emptyIndex].flowerColor = color
            // Generate random rotation between -10 and +10 degrees
            flowerSlots[emptyIndex].rotation = Double.random(in: -10...10)
            // Random horizontal flip for variety
            flowerSlots[emptyIndex].mirrored = Bool.random()
        }
    }
    
    func removeFlowerFromSlot(slotId: Int) {
        if let index = flowerSlots.firstIndex(where: { $0.id == slotId }) {
            flowerSlots[index].flowerColor = nil
            flowerSlots[index].rotation = nil
            flowerSlots[index].mirrored = nil
        }
    }
    
    func clearAllFlowers() {
        flowerSlots = (0..<9).map { FlowerSlot(id: $0) }
    }
    
    func randomizeBouquet() {
        // Fill all 9 slots with random flowers
        let colors: [FlowerColor] = [.yellow, .purple, .red]
        for i in 0..<9 {
            let randomColor = colors.randomElement() ?? .yellow
            flowerSlots[i].flowerColor = randomColor
            flowerSlots[i].rotation = Double.random(in: -10...10)
            flowerSlots[i].mirrored = Bool.random()
        }
    }
    
    var filledSlotsCount: Int {
        flowerSlots.filter { $0.flowerColor != nil }.count
    }
    
    var canAddMoreFlowers: Bool {
        filledSlotsCount < 9
    }
    
    // Legacy support for old Flower-based system
    func addFlower(type: FlowerType, color: FlowerColor) {
        // Position flowers inside smaller vase with tighter bounds
        let flowerIndex = Double(designingFlowers.count)
        
        // Create arrangement inside the smaller vase ellipse
        let angle = (flowerIndex * 137.5) * .pi / 180.0 // Golden angle
        let radius = 20.0 + (flowerIndex * 5.0) // Smaller spread for tighter vase
        
        let x = cos(angle) * radius
        let y = sin(angle) * radius - 95 // Center around new vase interior
        
        let flower = Flower(type: type, color: color, xPosition: x, yPosition: y, rotation: Double.random(in: -20...20))
        designingFlowers.append(flower)
    }
    
    func updateFlowerPosition(_ flower: Flower, position: CGPoint) {
        if let index = designingFlowers.firstIndex(where: { $0.id == flower.id }) {
            designingFlowers[index].xPosition = Double(position.x)
            designingFlowers[index].yPosition = Double(position.y)
        }
    }
    
    func removeFlower(_ flower: Flower) {
        designingFlowers.removeAll(where: { $0.id == flower.id })
    }
    
    func sendBouquet() {
        guard let partner = partner else { return }
        
        // Convert slots to flowers for bouquet (legacy compatibility)
        let flowers = flowerSlots.compactMap { slot -> Flower? in
            guard let color = slot.flowerColor else { return nil }
            let position = StemPosition.allPositions[slot.id]
            return Flower(
                type: .tulip, // Default type for now
                color: color,
                xPosition: position.x,
                yPosition: position.y,
                rotation: slot.rotation ?? 0
            )
        }
        
        // Filter to only filled slots for cleaner data
        let filledSlots = flowerSlots.filter { $0.flowerColor != nil }
        
        let bouquet = Bouquet(
            flowers: flowers, 
            flowerSlots: filledSlots, // Include rotation/mirror data!
            fromUserId: currentUser.id, 
            toUserId: partner.id
        )
        
        // Update streak
        if let lastSent = currentUser.lastBouquetSent,
           Calendar.current.isDate(lastSent, inSameDayAs: Date()) {
            // Already sent today, don't increment
        } else {
            currentUser.streakCount += 1
            streakCount = currentUser.streakCount
        }
        
        currentUser.lastBouquetSent = Date()
        currentBouquet = bouquet
        clearAllFlowers()
        
        // Save to local cache
        if let bouquetData = try? JSONEncoder().encode(bouquet) {
            UserDefaults.standard.set(bouquetData, forKey: "sentBouquet_\(partner.id)")
        }
        saveData()
        
        // Send to Firebase
        Task {
            do {
                try await firebaseService.sendBouquet(bouquet)
            } catch {
                print("Error sending bouquet: \(error.localizedDescription)")
            }
        }
    }
    
    func pairWithPartner(partnerId: String, partnerName: String) {
        let partner = User(id: partnerId, code: "0000", name: partnerName)
        self.partner = partner
        currentUser.partnerId = partnerId
        saveData()
        
        // Sync pairing to Firebase
        Task {
            do {
                try await firebaseService.pairUsers(userId: currentUser.id, partnerId: partnerId)
            } catch {
                print("Error pairing users: \(error.localizedDescription)")
            }
        }
    }
    
    // Pair with partner using their 4-digit code
    func pairWithCode(_ code: String) async -> Bool {
        do {
            guard let partner = try await firebaseService.getUserByCode(code) else {
                return false
            }
            
            // Don't pair with yourself
            guard partner.id != currentUser.id else {
                return false
            }
            
            self.partner = partner
            currentUser.partnerId = partner.id
            saveData()
            
            // Sync pairing to Firebase
            try await firebaseService.pairUsers(userId: currentUser.id, partnerId: partner.id)
            
            return true
        } catch {
            print("Error pairing with code: \(error.localizedDescription)")
            return false
        }
    }
    
    // Restore account from 4-digit code (for new device)
    func restoreFromCode(_ code: String) async -> Bool {
        do {
            guard let user = try await firebaseService.getUserByCode(code) else {
                return false
            }
            
            // Update current user
            self.currentUser = user
            self.streakCount = user.streakCount
            
            // Save to keychain and UserDefaults
            KeychainHelper.shared.saveUserId(user.id)
            saveData()
            
            // Sync with Firebase to get partner and bouquets
            await syncWithFirebase()
            
            return true
        } catch {
            print("Error restoring from code: \(error.localizedDescription)")
            return false
        }
    }
    
    func generateInviteLink() -> String {
        let userId = currentUser.id
        return "flowers://invite/\(userId)"
    }
    
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.checkBouquetExpiration()
            }
        }
    }
    
    private func checkBouquetExpiration() {
        if let bouquet = receivedBouquet, bouquet.isExpired {
            receivedBouquet = nil
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

