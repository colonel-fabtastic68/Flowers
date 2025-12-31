//
//  PairingView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/30/25.
//

import SwiftUI

struct PairingView: View {
    @ObservedObject var viewModel: BouquetViewModel
    @Environment(\.dismiss) var dismiss
    @State private var enteredCode: String = ""
    @State private var showingError = false
    @State private var showingSuccess = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.92, blue: 0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // Your Code Display
                VStack(spacing: 16) {
                    Text("Your Code")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.currentUser.code)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.89, green: 0.36, blue: 0.38))
                        .tracking(10)
                    
                    Text("Share this code to receive flowers")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 40)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                )
                .padding(.horizontal)
                
                // Divider
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    Text("OR")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal, 40)
                
                // Enter Partner Code
                VStack(spacing: 20) {
                    Text("Enter Partner's Code")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                    
                    // 4-digit code input
                    TextField("0000", text: $enteredCode)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .tracking(10)
                        .onChange(of: enteredCode) { _, newValue in
                            // Limit to 4 digits
                            if newValue.count > 4 {
                                enteredCode = String(newValue.prefix(4))
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                    
                    Button(action: {
                        isLoading = true
                        Task {
                            let success = await viewModel.pairWithCode(enteredCode)
                            isLoading = false
                            if success {
                                showingSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            } else {
                                showingError = true
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 20))
                                Text("Connect")
                                    .font(.system(size: 20, weight: .bold))
                            }
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
                    .disabled(enteredCode.count != 4 || isLoading)
                    .opacity(enteredCode.count == 4 && !isLoading ? 1 : 0.5)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 40)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                )
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .alert("Code Not Found", isPresented: $showingError) {
            Button("OK", role: .cancel) {
                enteredCode = ""
            }
        } message: {
            Text("No user found with code \(enteredCode). Please check and try again.")
        }
        .alert("Connected! 🎉", isPresented: $showingSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can now send flowers to each other!")
        }
    }
}

#Preview {
    PairingView(viewModel: BouquetViewModel())
}

