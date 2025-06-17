import SwiftUI
import KeychainAccess

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoaded = false
    @Published var errorMessage: String?
    
    private let keychain = Keychain(service: "com.yourapp")
    private let apiUrl = "http://127.0.0.1:8000/api/categories"

    func fetchCategories() {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        guard let token = try? keychain.get("auth_token") else {
            self.errorMessage = "Authentication token not found"
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    self.categories = decodedResponse.categories
                } catch {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    print("Decoding error: \(error)") // Log decoding error
                }
                DispatchQueue.main.async {
                    self.isLoaded = true
                }
            }
        }.resume()
    }
}
