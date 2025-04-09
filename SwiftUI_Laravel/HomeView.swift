import SwiftUI

struct HomeView: View {
    @State private var showProductDetail = false // State to control when to show the modal
    @StateObject private var categoriesViewModel = CategoryViewModel()
    @StateObject private var productViewModel = ProductViewModel()
    private let baseURL = "http://127.0.0.1:8000/"
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Slideshow()

                        HStack {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(Color(white:0.2))
                            Spacer()
                            Button {
                                // Action for "See all"
                            } label: {
                                Text("See all")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, -20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 5) {
                                ForEach(categoriesViewModel.categories) { category in
                                    CategoryGrid(item: category)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 10)

                        HStack {
                            Text("Latest Products")
                                .font(.headline)
                                .foregroundColor(Color(white:0.2))
                            Spacer()
                            Button {
                                // Action for "See all"
                            } label: {
                                Text("See all")
                                    .font(.callout) 
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 20) 
                        .padding(.top, 10)
    
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(productViewModel.products) { product in
                                    ProductGrid(item: product)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 340)
                        }
                        .padding(.top, -10)
                        
                        HStack {
                            Text("Best Selling Products")
                                .font(.headline)
                                .foregroundColor(Color(white:0.2))
                            Spacer()
                            Button {
                                // Action for "See all"
                            } label: {
                                Text("See all")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, -5)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(productViewModel.products) { product in
                                    ProductGrid(item: product)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 340)
                        }
                        .padding(.top, -10)
                    }
                }
                .padding(.top, -10)
            }
            .onAppear {
                categoriesViewModel.fetchCategories()
                productViewModel.fetchProducts()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Present ProductDetailView as a sheet
                        showProductDetail.toggle() // This will trigger the sheet to show
                    } label: {
                        Image("semsethy")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(Color(white: 1), lineWidth: 2)
                            }
                            .shadow(radius: 5)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Hello, Sethy!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(white:0.1))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProductDetailView()){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(white: 0.2))
                            .padding(5)
                            .background(Color(white: 0.9))
                            .cornerRadius(6)
                            .font(.system(size: 15))
                            .frame(width: 35, height: 35)
                            .offset(x:16)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProductDetailView()){
                        Image(systemName: "cart.fill")
                            .foregroundColor(Color(white: 0.3))
                            .padding(5)
                            .background(Color(white: 0.9))
                            .cornerRadius(6)
                            .font(.system(size: 15))
                            .frame(width: 35, height: 35)
                    }
                }
            }
            // Sheet presentation logic (only for the leading button)
            .sheet(isPresented: $showProductDetail) {
                ProductDetailView() // Show the ProductDetailView as a modal
            }
        }
    }
}

#Preview {
    HomeView()
}





