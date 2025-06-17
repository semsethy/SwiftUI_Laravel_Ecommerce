//
//  WishListView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 16/3/25.
//

import SwiftUI
import KeychainAccess
struct WishListScreen: View {
    var body: some View {
        NavigationView {
            WishListView()
        }
    }
}
struct WishListView: View {
    @StateObject private var wishlistViewModel = WishlistViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    @State private var delayCompleted = false

    // Computed properties
    var isReady: Bool { wishlistViewModel.isLoaded }
    var showContent: Bool { isReady && delayCompleted }
    var body: some View {
        VStack {
            if wishlistViewModel.wishlistProducts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)

                    Text("Your Wish List is empty")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .transition(.opacity)
            } else {
                if showContent {
                    ScrollView {
                        if wishlistViewModel.wishlistProducts.isEmpty {
                            Text("No products in wishlist")
                                .padding()
                        } else {
                            LazyVGrid(columns: columns, spacing: 5) {
                                ForEach(wishlistViewModel.wishlistProducts) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(wishlistViewModel)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                } else {
                    // Loading state with ProgressView
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(0..<6) { _ in
                                ProductSkimmer()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                    .transition(.opacity)
                }
            }
        }
        .navigationTitle(Text("Wish Lists"))
        .animation(.easeInOut(duration: 0.4), value: showContent)
        .onAppear {
            wishlistViewModel.fetchWishlist()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                delayCompleted = true
            }
        }
    }
}
