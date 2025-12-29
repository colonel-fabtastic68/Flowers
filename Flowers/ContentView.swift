//
//  ContentView.swift
//  Flowers
//
//  Created by Baker Cobb on 12/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BouquetViewModel()
    
    var body: some View {
        HomeView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
