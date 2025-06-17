//
//  CartViewModel.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 21/4/25.
//


import Foundation
import Combine
import KeychainAccess

class CartViewModel: ObservableObject {
    @Published var cartItems: [ProcessedCartItem] = []
    @Published var isLoading = false
    @Published var cartItemCount: Int = 0
    @Published var errorMessage: String?
    private let keychain = Keychain(service: "com.yourapp")
    var totalPrice: Double {
        cartItems.reduce(0) { total, item in
            let price: Double
            if item.product.discount != "0.00",
               let discountPrice = Double(item.product.discount) {
                price = discountPrice
            } else if let regularPrice = Double(item.product.price) {
                price = regularPrice
            } else {
                price = 0.0
            }
            return total + (price * Double(item.quantity))
        }
    }

    func clearCart() {
        DispatchQueue.main.async {
            self.cartItems = []
            self.cartItemCount = 0
            self.errorMessage = nil
            self.isLoading = false
        }
    }

    func fetchCart() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/cart") else { return }
        guard let token = try? keychain.get("auth_token") else {
            self.errorMessage = "Authentication token not found"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received."
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CartResponse.self, from: data)
                let processedItems = decodedResponse.cart.compactMap { $0.toProcessedItem() }
                DispatchQueue.main.async {
                    self?.cartItems = processedItems
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }

            DispatchQueue.main.async {
                print("cart:", self?.cartItems ?? [])
            }
        }.resume()
    }
    func fetchCartItemCount() {
        guard let token = try? keychain.get("auth_token") else { return }
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/cart/count")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let result = try? JSONDecoder().decode(CartCountResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.cartItemCount = result.countValue
                }
            }
        }.resume()
    }
}


