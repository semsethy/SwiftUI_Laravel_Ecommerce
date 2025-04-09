import SwiftUI

// Define the structure of the Category model
struct Category: Identifiable, Codable {
    var id: Int
    var title: String
    var image: String?
    var status: Int
}
struct CategoryResponse: Codable {
    var status: Bool
    var categories: [Category]
}

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var loading = false
    @Published var errorMessage: String?

    private let apiUrl = "http://127.0.0.1:8000/api/categories"
    private let authToken = "2|I9vpMTF6qZd1XxvzEyM37bInQKjDlZXx2tVm5sTVc0d0094b"
    
    // Fetch categories from the API
    func fetchCategories() {
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        self.loading = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.loading = false
                if let error = error {
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                // Decode the response into CategoryResponse
                do {
                    let decodedResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    self.categories = decodedResponse.categories
                } catch {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    print("Decoding error: \(error)") // Log decoding error
                }
            }
        }.resume()
    }
}


struct CategoryListView: View {
    @StateObject private var viewModel = CategoryViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        List(viewModel.categories) { category in
                            HStack {
                                if let imageUrl = category.image, let url = URL(string: imageUrl) {
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
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(category.image ?? "")
                                        .font(.headline)
                                    Text(category.status == 1 ? "Active" : "Inactive")
                                        .font(.subheadline)
                                        .foregroundColor(category.status == 1 ? .green : .red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Categories")
            .onAppear {
                viewModel.fetchCategories()
            }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
