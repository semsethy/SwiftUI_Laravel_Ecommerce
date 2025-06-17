import KeychainAccess
import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products = [Product]()
    @Published var isLoaded = false
    @Published var errorMessage: String? = nil
    private let keychain = Keychain(service: "com.yourapp")
    private let url = "http://127.0.0.1:8000/api/gets"

    private let cacheKey = "cached_products"

    func fetchProducts() {
        guard let url = URL(string: self.url) else { return }
        guard let token = try? keychain.get("auth_token") else {
            self.errorMessage = "Authentication token not found"
            return
        }

        errorMessage = nil
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    self?.loadCachedProducts() // Load cache on error
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received."
                    self?.loadCachedProducts() // Load cache on error
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                let products = decodedResponse.toProducts()

                DispatchQueue.main.async {
                    self?.products = products
                    self?.cacheProducts(products)
                    self?.isLoaded = true
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding failed: \(error)")
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                    self?.loadCachedProducts() // Fallback
                }
            }
        }.resume()
    }

    private func cacheProducts(_ products: [Product]) {
        do {
            let encodedData = try JSONEncoder().encode(products)
            UserDefaults.standard.set(encodedData, forKey: cacheKey)
        } catch {
            print("Failed to cache products: \(error)")
        }
    }

    private func loadCachedProducts() {
        if let data = UserDefaults.standard.data(forKey: cacheKey) {
            do {
                let cachedProducts = try JSONDecoder().decode([Product].self, from: data)
                self.products = cachedProducts
                self.isLoaded = true
            } catch {
                print("Failed to load cached products: \(error)")
            }
        }
    }

}


