import SwiftUI

struct ProductGridList: View {
    @StateObject private var productViewModel = ProductViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    @State private var delayCompleted = false
    var type = ""
    var isReady: Bool { productViewModel.isLoaded }
    var showContent: Bool { isReady && delayCompleted }

    var body: some View {
        VStack {
            if showContent {
                
                ScrollView {
                    if productViewModel.products.isEmpty{
                        VStack(spacing: 16) {
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)

                            Text("No Products Found")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .transition(.opacity)
                    } else {
                        if type == ""{
                            VStack(spacing: 16) {
                                Image(systemName: "cart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)

                                Text("No Products Found")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .transition(.opacity)
                            .padding(.top,300)
                        }
                        LazyVGrid(columns: columns, spacing: 5) {
                            if type == "nodiscount"{
                                ForEach(productViewModel.products.filter { $0.discount == "0.00" }) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(productViewModel)
                                }
                            } else if type == "discount"{
                                ForEach(productViewModel.products.filter { $0.discount != "0.00" }) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(productViewModel)
                                }
                            } else if type != "" {
                                ForEach(productViewModel.products.filter { $0.category?.title == type }) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(productViewModel)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .transition(.opacity)
            } else {
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(white: 0.4, alpha: 1))))
                        .scaleEffect(1)

                    Text("Loading Products...")
                        .font(.headline)
                        .foregroundColor(Color(UIColor(white: 0.4, alpha: 1)))
                }
                .transition(.opacity)
                
            }
        }
        .navigationTitle("All Products")
        .animation(.easeInOut(duration: 0.4), value: showContent)
        .onAppear {
            productViewModel.fetchProducts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                delayCompleted = true
            }
        }
    }
}

