import SwiftUI
import KeychainAccess
struct ProductDetailView: View {
    @State private var currentSliderIndex = 0
    @State private var isHearted = false
    @State private var screenWidth: Double = UIScreen.main.bounds.width
    @State private var screenHeight: Double = UIScreen.main.bounds.height
    @StateObject private var productViewModel = ProductViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @State private var loginMessage: String = ""
    private let keychain = Keychain(service: "com.yourapp")
    @State private var num = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var cartItemCount: Int = 0
    let product: Product
    private let baseURL = "http://127.0.0.1:8000/"
    
    @State private var delayCompleted = false
    var isReady: Bool {
        productViewModel.isLoaded
    }
    var showContent: Bool {
        isReady && delayCompleted
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ImageCollection(imageURLs: product.collectionImageURL)
                    .padding(.top, 20)
                    .padding(.bottom, -30)
                VStack(alignment: .leading) {
                    HStack {
                        let imageURLString = baseURL + "storage/" + product.mainImageURL
                        if let url = URL(string: imageURLString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable().padding(10).frame(width: 80, height: 80).background(Color(white: 0.9)).cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        }
                        Text(product.productName)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                        Spacer()
                        Button {
                            isHearted.toggle()
                            if isHearted {
                                addToWishlist()
                            } else {
                                removeFromWishlist()
                            }
                        } label: {
                            Image(systemName: isHearted ? "heart.fill" : "heart")
                                .resizable()
                                .foregroundColor(Color(white: 0.3))
                                .font(.system(size: 5))
                                .frame(width: 15, height: 15)
                                .padding(15)
                                .background(Color(white: 0.93))
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                    Spacer()
                    Text("Description: ")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                        .bold()
                    +
                    Text("Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem!. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem!")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                    Spacer()
                    Text("Category: ")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                        .bold()
                    +
                    Text("\(product.category?.title ?? "Unknown")")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                    Spacer()
                    
                    if product.discount != "0.00" {
                        Text("Price: ")
                            .font(.system(size: 15))
                            .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                            .bold()
                        +
                        Text("$\(product.discount)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        +
                        Text(" ")
                        +
                        Text("$\(product.price)")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .strikethrough(true, color: .gray)
                    } else {
                        Text("Price: ")
                            .font(.system(size: 15))
                            .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                            .bold()
                        +
                        Text("$\(product.price)")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("In Stock: ")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                        .bold()
                    +
                    Text("\(product.stockQuantity)")
                        .font(.system(size: 15))
//                        .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                        .foregroundColor(.green)
                        .bold()
                    Spacer()
                    Spacer()
                    Text("Related Products")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(UIColor(white: 0.3, alpha: 1)))
                    if !showContent {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(1...3, id: \.self) { _ in
                                    ProductSkimmer()
                                }
                            }
                            .frame(height: 340)
                        }
                        .padding(.top, -10)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(productViewModel.products.filter { $0.category?.title == product.category?.title }) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(cartViewModel)
                                }
                            }
                            .frame(height: 300)
                        }
                        .padding(.top, -5)
                    }
                }
                .padding()
                .background(Color(UIColor(white: 1, alpha: 1)))
                .cornerRadius(25)
            }
            .background(Color(UIColor(white: 1, alpha: 1)))
            HStack(spacing: 15) {
                HStack(spacing: 15) {
                    Button {
                        if num == 0 {
                            
                        } else {
                            num -= 1
                        }
                    } label: {
                        Image(systemName: "minus.square").foregroundStyle(.red).font(.system(size: 25))
                    }
                    Text("\(num)").font(.system(size: 18)).frame(width: 25)
                    Button {
                        num += 1
                    } label: {
                        Image(systemName: "plus.square").foregroundStyle(.red).font(.system(size: 25))
                    }
                }
                Button(action: {
                    addToCart()
                }) {
                    Image(systemName: "cart")
                        .bold()
                        .foregroundColor(Color(white: 1))
                        .padding(5)
                        .font(.system(size: 15))
                        .frame(width: 35, height: 35)
                    Text("Add To Cart")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .bold()
                }
                .padding([.top, .bottom], 5)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(8)
            }
            .padding([.leading, .trailing], 15)
            .padding([.top, .bottom], 10)
        }
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .navigationTitle(Text("Product Detail"))
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.4), value: showContent)
        .onAppear {
            productViewModel.fetchProducts()
            cartViewModel.clearCart()
            cartViewModel.fetchCartItemCount()
            checkIfInWishlist()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                delayCompleted = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Added Successfully"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ShoppingCartView()) {
                    ZStack{
                        Image(systemName: "cart.fill")
                            .foregroundColor(Color(white: 0.3))
                            .padding(5)
                            .background(Color(white: 0.9))
                            .cornerRadius(6)
                            .font(.system(size: 15))
                            .frame(width: 35, height: 35)
                        if cartViewModel.cartItemCount > 0 {
                            Text("\(cartViewModel.cartItemCount)")
                                .font(.caption2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 12, y: -18)
                        }
                        
                    }
                }
            }
        }
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
                DispatchQueue.main.async {
                    self.isHearted = wishlistItems.contains { $0.product.id == self.product.id }
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
        guard let url = URL(string: "http://127.0.0.1:8000/api/wishlist/\(product.id)") else {
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
            "product_id": product.id
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
        let url = URL(string: "http://127.0.0.1:8000/api/cart")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = [
            "product_id": product.id,
            "quantity": num
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = try? keychain.get("auth_token") else {
            self.loginMessage = "Authentication token not found"
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Cart update failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        alertMessage = "\(num) Product(s) added to the cart"
                        showAlert = true
                        cartViewModel.fetchCartItemCount()
                        num = 0
                    }
                } else {
                    DispatchQueue.main.async {
                        alertMessage = "Failed to add product. Status code: \(httpResponse.statusCode)"
                        showAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    alertMessage = "Invalid response received"
                    showAlert = true
                }
            }
        }.resume()
    }
}



