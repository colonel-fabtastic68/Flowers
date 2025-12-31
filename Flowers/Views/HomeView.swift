//
//  HomeView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI
import MessageUI

struct HomeView: View {
    @ObservedObject var viewModel: BouquetViewModel
    @State private var showingPairingView = false
    @State private var showingDesignView = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.92, blue: 0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Main content
                if viewModel.hasPartner {
                    // Has partner - show send flowers button
                    VStack(spacing: 20) {
                        VStack(spacing: 20) {
                            // Large flower icon
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.8))
                                    .frame(width: 150, height: 150)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20)
                                
                                SimpleFlowerView(type: .tulip, color: .yellow, size: 80)
                            }
                            
                            Text("Ready to Send?")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                            
                            if let partner = viewModel.partner {
                                Text("Sending to \(partner.name)")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Streak
                            HStack(spacing: 12) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)
                                Text("\(viewModel.streakCount) Day Streak")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.orange)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.8))
                            )
                        }
                    }
                } else {
                    // No partner - show welcome
                    VStack(spacing: 20) {
                        // Large flower icon
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 150, height: 150)
                                .shadow(color: Color.black.opacity(0.1), radius: 20)
                            
                            SimpleFlowerView(type: .tulip, color: .yellow, size: 80)
                        }
                        
                        Text("Welcome to Flowers")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                        
                        Text("Share beautiful flower bouquets\nwith someone special")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    if viewModel.hasPartner {
                        Button(action: {
                            showingDesignView = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 20))
                                Text("Create Bouquet")
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
                        
                        Button(action: {
                            showingPairingView = true
                        }) {
                            HStack(spacing: 8) {
                                Text("Your Code:")
                                    .font(.system(size: 14))
                                Text(viewModel.currentUser.code)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .tracking(3)
                            }
                            .foregroundColor(Color(red: 0.89, green: 0.36, blue: 0.38))
                        }
                    } else {
                        Button(action: {
                            showingPairingView = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.system(size: 20))
                                Text("Connect with Partner")
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
                        
                        Text("Each bouquet lasts 24 hours\nKeep your streak going!")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showingPairingView) {
            PairingView(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $showingDesignView) {
            BouquetDesignView(viewModel: viewModel)
        }
    }
}

struct OldHomeView: View {
    @ObservedObject var viewModel: BouquetViewModel
    @State private var showingDesignView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.98, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.92, blue: 0.88)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if true {
                    // Has partner view
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your Partner")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Text(viewModel.partner?.name ?? "")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.95, green: 0.75, blue: 0.79))
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // Streak
                            HStack(spacing: 12) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.orange)
                                Text("\(viewModel.streakCount) Day Streak")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.orange)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.8))
                            )
                        }
                        .padding()
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                // Received bouquet
                                if let received = viewModel.receivedBouquet {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("From \(viewModel.partner?.name ?? "Your Partner")")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                                        
                                        NavigationLink(destination: BouquetDisplayView(bouquet: received)) {
                                            BouquetPreviewCard(bouquet: received)
                                        }
                                    }
                                    .padding()
                                }
                                
                                // Sent bouquet
                                if let sent = viewModel.currentBouquet {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Your Bouquet")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.3))
                                        
                                        BouquetPreviewCard(bouquet: sent)
                                    }
                                    .padding()
                                }
                                
                                // Create new bouquet button
                                Button(action: {
                                    showingDesignView = true
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 24))
                                        Text("Create New Bouquet")
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
                        }
                    }
                }
            }
        }
    }
}

struct BouquetPreviewCard: View {
    let bouquet: Bouquet
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.black.opacity(0.1), radius: 10)
            
            VStack {
                ZStack {
                    // Custom vase image
                    Image("CustomVase")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 120)
                        .offset(y: 40)
                    
                    ForEach(bouquet.flowers.prefix(5)) { flower in
                        SimpleFlowerView(type: flower.type, color: flower.color, size: 35)
                            .rotationEffect(.degrees(flower.rotation))
                            .offset(x: flower.xPosition * 0.5, y: flower.yPosition * 0.5)
                    }
                }
                .frame(height: 180)
                
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                    Text(timeString(from: bouquet.timeRemaining))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                }
                .padding(.bottom, 8)
            }
            .padding()
        }
        .frame(height: 250)
    }
    
    private func timeString(from interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return String(format: "%02dh %02dm remaining", hours, minutes)
    }
}

struct MessageComposeView: UIViewControllerRepresentable {
    let recipients: [String]
    let body: String
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.recipients = recipients
        controller.body = body
        controller.messageComposeDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
}

#Preview {
    HomeView(viewModel: BouquetViewModel())
}

