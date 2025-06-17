import Foundation
import Combine
import KeychainAccess

class WishlistViewModel: ObservableObject {
    @Published var wishlistProducts: [Product] = []
    @Published var errorMessage: String = ""
    @Published var isLoaded = false

    private let keychain = Keychain(service: "com.yourapp")

    func fetchWishlist() {
        guard let token = try? keychain.get("auth_token") else {
            self.errorMessage = "Authentication token not found"
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/api/wishlist") else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Fetch error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(WishlistResponse.self, from: data)
                DispatchQueue.main.async {
                    self.wishlistProducts = decoded.wishlist.compactMap { try? $0.product.toProduct() }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
            DispatchQueue.main.async {
                self.isLoaded = true
            }
        }.resume()
    }
}


