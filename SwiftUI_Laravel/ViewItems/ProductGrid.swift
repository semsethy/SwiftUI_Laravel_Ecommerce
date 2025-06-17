import SwiftUI
import KeychainAccess

// Custom shape to allow corner radius on specific corners
struct RoundedCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ProductGrid: View {
    @State private var isHearted = false
    let item: Product
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    private let keychain = Keychain(service: "com.yourapp")
    @State private var loginMessage: String = ""
    private let baseURL = "http://127.0.0.1:8000/"
    
    var body: some View {
        let discountPercentage = calculateDiscountPercentage(price: item.price, discount: item.discount)
        VStack(alignment: .center) {
            HStack{
                if item.discount != "0.00" {
                    Text("-\(discountPercentage)%")
                        .font(.caption)
                        .padding(5)
                        .foregroundColor(Color.red)
                        .bold()
                        .frame(width: 50, height: 50)
                        .background(Color(white: 1))
                        .clipShape(Circle())
                } else {
                    Text("New")
                        .font(.caption)
                        .padding(5)
                        .foregroundColor(Color.green)
                        .bold()
                        .frame(width: 50, height: 50)
                        .background(Color(white: 1))
                        .clipShape(Circle())
                }
                Spacer()
                Button{
                    isHearted.toggle()
                    if isHearted {
                        addToWishlist()
                    } else {
                        removeFromWishlist()
                    }
                }label:{
                    Image(systemName: isHearted ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(Color(white: 0.3))
                        .font(.system(size: 5))
                        .frame(width: 20, height: 20)
                        .padding(15)
                        .background(Color(white: 1))
                        .clipShape(Circle())
                }
            }
            .padding([.leading, .trailing, .top], 10)
            .padding(.bottom,-5)
            
            NavigationLink(destination: ProductDetailView(product: item).navigationBarHidden(false)){
                let imageURLString = baseURL + "storage/" + item.mainImageURL
                let size = 140
                if let url = URL(string: imageURLString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(Double(size)/1.2), height: CGFloat(size))
                            .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                            .clipped()
                            .padding(.bottom,-10)
                            .padding(.top,-10)
                            .padding([.leading,.trailing],15)
                    } placeholder: {
                        SkimmerEffectBox()
                            .frame(height: 180)
                            .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                            .clipped()
                            .padding(.bottom,-10)
                            .padding(.top,-10)
                            .padding([.leading,.trailing],15)
                    }
                } else {
                    Image("applewatch")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                        .clipped()
                        .padding(.bottom,-10)
                        .padding(.top,-10)
                        .padding([.leading,.trailing],15)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.productName)
                    .font(.subheadline)
                    .foregroundColor(Color(white: 0.2))
                HStack(spacing: 5) {
                    if item.discount != "0.00"{
                        Text("$\(item.discount)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        
                        Text("$\(item.price)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .strikethrough(true, color: .gray)
                    } else {
                        Text("$\(item.price)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                HStack{
                    Text(item.category?.title ?? "Category")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        addToCart()
                        cartViewModel.fetchCartItemCount()
                    } label: {
                        Image(systemName: "cart")
                            .foregroundColor(Color(white: 0.3))
                            .padding(5)
                            .background(Color(white: 0.9))
                            .cornerRadius(6)
                    }
                }
            }
            .padding(8)
            .background(Color.white)
            .clipShape(RoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 15))
            .padding([.leading, .trailing, .bottom], 10)
        }
        .onAppear {
            cartViewModel.fetchCartItemCount()
            checkIfInWishlist()
        }
        .background(Color(white: 0.9))
        .cornerRadius(20)
        .frame(width: 170, height: 300)
        
        
    }
    func calculateDiscountPercentage(price: String, discount: String) -> Int {
        guard let priceValue = Double(price),
              let discountValue = Double(discount),
              priceValue > 0 else {
            return 0
        }
        
        let percentage = (priceValue - discountValue) / priceValue * 100
        return Int(percentage.rounded())
    }
    func checkIfInWishlist() {
        guard let token = try? keychain.get("auth_token") else {
            self.loginMessage = "Authentication token not found"
            print("Error: Authentication token not found")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/api/wishlist") else {
            self.loginMessage = "Invalid URL"
            print("Error: Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginMessage = "Error fetching wishlist: \(error.localizedDescription)"
                    print("Network error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.loginMessage = "No data returned"
                    print("Error: No data returned")
                }
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(WishlistResponse.self, from: data)
                let wishlistItems = decodedResponse.wishlist

                // Print the wishlist items
                DispatchQueue.main.async {
                    self.isHearted = wishlistItems.contains { $0.product.id == item.id }
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginMessage = "Failed to decode wishlist: \(error.localizedDescription)"
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }



    func removeFromWishlist() {
        guard let token = try? keychain.get("auth_token") else {
            self.loginMessage = "Authentication token not found"
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/api/wishlist/\(item.id)") else {
            self.loginMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }

            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    self.loginMessage = "Removed from wishlist"
                    self.wishlistViewModel.fetchWishlist()
                } else {
                    self.loginMessage = "Failed to remove from wishlist"
                }
            }
        }.resume()
    }

    func addToWishlist() {
        guard let token = try? keychain.get("auth_token") else {
            self.loginMessage = "Authentication token not found"
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/api/wishlist") else {
            self.loginMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = [
            "product_id": item.id
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginMessage = "Wishlist error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }

            DispatchQueue.main.async {
                if httpResponse.statusCode == 200 {
                    self.loginMessage = "Added to wishlist"
                } else {
                    self.loginMessage = "Failed to add to wishlist"
                }
            }
        }.resume()
    }
    func addToCart() {
        // Your backend URL for adding a product to the cart
        
        let url = URL(string: "http://127.0.0.1:8000/api/cart")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // The body of the POST request
        let body = [
            "product_id": item.id, // Use the product's ID
            "quantity": 1      // Quantity of the product to add
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = try? keychain.get("auth_token") else {
            self.loginMessage = "Authentication token not found"
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Send the request to add to the cart
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            // Check for a valid response
            if let data = data {
                do {
                    // Check if you have a valid response from the backend
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(CartResponse.self, from: data)
                } catch {
                    DispatchQueue.main.async {
                        self.loginMessage = "Failed to decode response: \(error.localizedDescription)"
                    }
                }
            }
        }
        
        task.resume()
    }
}




struct ProductSkimmer: View {
    var body: some View {
        VStack(alignment: .center) {
            // Top badge and heart icon placeholder
            HStack {
                SkimmerEffectBox()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                Spacer()
                
                SkimmerEffectBox()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            .padding([.leading, .trailing, .top], 10)
            .padding(.bottom, -5)
            
            // Product Image placeholder
            SkimmerEffectBox()
                .frame(width: CGFloat(Double(140)/0.9), height: 140)
//                .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
//                .padding(.bottom, -10)
//                .padding(.top, -10)
//                .padding([.leading, .trailing], 15)

            // Product info placeholders
            VStack(alignment: .leading, spacing: 6) {
                SkimmerEffectBox()
                    .frame(width: 100, height: 10)
                
                SkimmerEffectBox()
                    .frame(width: 80, height: 10)
                
                HStack {
                    SkimmerEffectBox()
                        .frame(width: 100, height: 10)
                    
                    Spacer()
                    
                    SkimmerEffectBox()
                        .frame(width: 30, height: 30)
                        .cornerRadius(6)
                }
            }
            .padding(8)
            .background(Color.white)
            .clipShape(RoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 15))
            .padding([.leading, .trailing, .bottom], 10)
        }
        .background(Color(white: 0.9))
        .cornerRadius(20)
        .frame(width: 170, height: 290) // Adjust height to match actual `ProductGrid`
    }
}

#Preview {
    ProductSkimmer()
}

