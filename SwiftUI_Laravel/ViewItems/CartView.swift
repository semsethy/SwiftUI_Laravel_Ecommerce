import SwiftUI
import KeychainAccess

struct CartView: View {
    let cartItem: ProcessedCartItem
    var onDelete: () -> Void
    var onQuantityChanged: () -> Void // Trigger re-fetch or state update

    private let baseURL = "http://127.0.0.1:8000/"
    private let keychain = Keychain(service: "com.yourapp")
    
    @State private var showDeleteConfirmation = false
    @State private var loginMessage: String = ""

    var body: some View {
        let item = cartItem.product
        HStack {
            let imageURLString = baseURL + "storage/" + item.mainImageURL
            if let url = URL(string: imageURLString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .padding(10)
                        .frame(width: 70, height: 70)
                        .background(Color(white: 1))
                        .cornerRadius(10)
                } placeholder: {
                    Image("applewatch")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .background(Color(white: 1))
                        .cornerRadius(10)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    VStack(alignment: .leading,spacing:5) {
                        Text(item.productName)
                            .font(.system(size: 17, weight: .medium))
                            .lineLimit(1)
                            .foregroundColor(Color(white: 0.2))
                            .bold()

                        Text(item.category?.title ?? "Category")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    Spacer()
                    VStack{
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 15, height: 15)
                                .padding(7)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }

                HStack {
                    // Price Display
                    if item.discount != "0.00", let discount = Double(item.discount), let original = Double(item.price) {
                        Text("$\(discount, specifier: "%.2f")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                        Text("$\(original, specifier: "%.2f")")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .strikethrough()
                    } else if let price = Double(item.price) {
                        Text("$\(price, specifier: "%.2f")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                    }

                    Spacer()

                    HStack(spacing: 18) {
                        Button { minusCart() } label: {
                            Text("-").font(.system(size: 20)).foregroundColor(Color(white: 0.2))
                        }

                        Text("\(cartItem.quantity)")
                            .font(.system(size: 15, weight: .medium))

                        Button { addCart() } label: {
                            Text("+").font(.system(size: 18)).foregroundColor(Color(white: 0.2))
                        }
                    }
                    .frame(width: 80, height: 20)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                }
            }
        }
        .padding(10)
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.vertical, 3)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Remove Item"),
                message: Text("Are you sure you want to remove this item from your cart?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteItem()
                },
                secondaryButton: .cancel()
            )
        }
    }


    func deleteItem() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/cart/\(cartItem.id)"),
              let token = try? keychain.get("auth_token") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Delete error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async { onDelete() }
            }
        }.resume()
    }

    func addCart() {
        updateCart(quantity: cartItem.quantity + 1)
    }

    func minusCart() {
        guard cartItem.quantity > 0 else { return }
        updateCart(quantity: cartItem.quantity - 1)
    }

    func updateCart(quantity: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/cart/\(cartItem.id)"),
          let token = try? keychain.get("auth_token") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let body = ["product_id": cartItem.product.id, "quantity": quantity] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Cart update failed: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                onQuantityChanged()
            }
        }.resume()
    }
}


