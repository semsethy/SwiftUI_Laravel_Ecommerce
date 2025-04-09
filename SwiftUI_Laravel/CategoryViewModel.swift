import Foundation
import SwiftUI

// MARK: - Root Response
struct ProductResponse: Codable {
    let status: Bool
    let products: [Product]
    let totalPages: Int
    let currentPage: Int
    let totalProducts: Int

    enum CodingKeys: String, CodingKey {
        case status
        case products
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case totalProducts = "total_products"
    }
}

// MARK: - Product
import Foundation

// MARK: - Product
struct Product: Codable, Identifiable {
    let id: Int
    let productName: String
    let description: String
    let price: String
    let stockQuantity: Int
    let status: Int
    let mainImageURL: String
    let collectionImageURL: [String]
    let categoryID: Int
    let createdAt: String
    let updatedAt: String
    let category: Categorys

    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case description
        case price
        case stockQuantity = "stock_quantity"
        case status
        case mainImageURL = "main_image_url"
        case collectionImageURL = "collection_image_url"
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category
    }

    // Custom decoding for collectionImageURL to convert the string representation of the array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decoding all properties except for collectionImageURL
        self.id = try container.decode(Int.self, forKey: .id)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(String.self, forKey: .price)
        self.stockQuantity = try container.decode(Int.self, forKey: .stockQuantity)
        self.status = try container.decode(Int.self, forKey: .status)
        self.mainImageURL = try container.decode(String.self, forKey: .mainImageURL)
        self.categoryID = try container.decode(Int.self, forKey: .categoryID)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.category = try container.decode(Categorys.self, forKey: .category)
        
        // Handling the collectionImageURL which is stored as a string containing a JSON array
        let collectionImageURLString = try container.decode(String.self, forKey: .collectionImageURL)
        if let data = collectionImageURLString.data(using: .utf8) {
            let decodedURLs = try JSONDecoder().decode([String].self, from: data)
            self.collectionImageURL = decodedURLs
        } else {
            self.collectionImageURL = [] // Default to an empty array if decoding fails
        }
    }
}


// MARK: - Category
struct Categorys: Codable {
    let id: Int
    let title: String
    let image: String
    let status: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

class ProductViewModel: ObservableObject {
    @Published var products = [Product]()
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let url = "http://127.0.0.1:8000/api/products" // Replace with your actual API URL
    private let authToken = "2|I9vpMTF6qZd1XxvzEyM37bInQKjDlZXx2tVm5sTVc0d0094b"

    func fetchProducts() {
        guard let url = URL(string: self.url) else { return }
        
        isLoading = true
        errorMessage = nil
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
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
            
            // Log the raw response data for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)") // Print the raw data to the console
            } else {
                print("Unable to convert data to string")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.products = decodedResponse.products
                    
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}



struct ProductListView: View {
    @StateObject private var viewModel = ProductViewModel()

    // Adjust the base URL if needed
    private let baseURL = "http://127.0.0.1:8000/" // Make sure this is the correct base URL for your API

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.products) { product in
                        VStack(alignment: .leading) {
                            // Construct the full image URL
                            let imageURLString = baseURL + "storage/" + product.mainImageURL
                            
                            // Check if the URL is valid
                            if let url = URL(string: imageURLString) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .background(Color(white: 0.9))
                                        .clipShape(Circle())
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .background(Color(white: 0.9))
                                        .clipShape(Circle())
                                }
                            } else {
                                // Default image if URL is invalid
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                            }

                            // Display product name and description
                            Text(imageURLString)
                                .font(.headline)
                            Text(product.description)
                                .font(.subheadline)

                            // Display price
                            Text("Price: $\(product.price)")
                                .font(.body)
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                viewModel.fetchProducts()
            }
            .navigationTitle("Products")
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
