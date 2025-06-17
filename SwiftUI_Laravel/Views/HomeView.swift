import SwiftUI

struct HomeView: View {
    @State private var showProductDetail = false
    @StateObject private var categoriesViewModel = CategoryViewModel()
    @StateObject private var productViewModel = ProductViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var slideshowViewModel = SlideshowViewModel()
    @State private var delayCompleted = false
    var isReady: Bool {
        categoriesViewModel.isLoaded &&
        productViewModel.isLoaded &&
        slideshowViewModel.isLoaded
    }
    var showContent: Bool {
        isReady && delayCompleted
    }
    var body: some View {
        VStack(spacing: 0) {
            topBar
            if !showContent {
                HomeSkimmer()
                    .transition(.opacity)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ImageSlideshowView(slideshows: slideshowViewModel.slideshows)
                            .padding(.horizontal, 10)
                        sectionHeader(title: "Categories")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(categoriesViewModel.categories) { category in
                                    CategoryGrid(item: category)
                                }
                            }.padding(.horizontal, 10)
                        }
                        sectionHeader(title: "Discount Products")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(productViewModel.products.filter { $0.discount != "0.00" }) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(cartViewModel)
                                }
                            }
                            .frame(height: 300)
                            .padding(.horizontal, 10)
                        }
                        sectionHeader(title: "New Arrivals Products")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(productViewModel.products.filter { $0.discount == "0.00" }) { product in
                                    ProductGrid(item: product)
                                        .environmentObject(cartViewModel)
                                }
                            }
                            .frame(height: 300)
                            .padding(.horizontal, 10)
                        }
                    }
                    .padding(.top, 10)
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showContent)
        .onAppear {
            categoriesViewModel.fetchCategories()
            productViewModel.fetchProducts()
            cartViewModel.clearCart()
            cartViewModel.fetchCartItemCount()
            slideshowViewModel.fetchSlideshows()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                delayCompleted = true
            }
        }
        .sheet(isPresented: $showProductDetail) {
            ProfileView()
        }
    }
    // MARK: - Top Bar
    var topBar: some View {
        HStack {
            Button {
                showProductDetail.toggle()
            } label: {
                Image("semsethy")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
            }
            Text("Hello, Sethy!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(white: 0.1))
            Spacer()
            NavigationLink(destination: ShoppingCartView().environmentObject(cartViewModel)) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(white: 0.2))
                    .padding(5)
                    .background(Color(white: 0.9))
                    .cornerRadius(6)
                    .font(.system(size: 20))
                    .frame(width: 35, height: 35)
            }

            NavigationLink(destination: ShoppingCartView().environmentObject(cartViewModel)) {
                ZStack {
                    Image(systemName: "cart.fill")
                        .foregroundColor(Color(white: 0.3))
                        .padding(5)
                        .background(Color(white: 0.9))
                        .cornerRadius(6)
                        .font(.system(size: 20))
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
        .padding(.horizontal, 10)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
    // MARK: - Section Header
    func sectionHeader(title: String) -> some View {
        var subtitle = ""
        if title == "New Arrivals Products" {
            subtitle = "nodiscount"
        } else if title == "Discount Products" {
            subtitle = "discount"
        }
        return HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(white: 0.2))
                .frame(height: 10)
            Spacer()
            NavigationLink(destination: ProductGridList(type: subtitle)) {
                Text("See all")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .frame(height: 10)
            }
        }
        .padding(.horizontal, 10)
    }
}
#Preview {
    HomeView()
}

struct HomeSkimmer: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                SkimmerEffectBox()
                    .frame(height: 180)
                    .cornerRadius(12)
                HStack {
                    SkimmerEffectBox()
                        .frame(width:100,height: 10)
                        .cornerRadius(5)
                    Spacer()
                    SkimmerEffectBox()
                        .frame(width:50,height: 10)
                        .cornerRadius(5)
                }
                .padding(.top,10)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center,spacing: 5) {
                        ForEach(1...4, id: \.self) { _ in
                            CategorySkimmer()
                        }
                    }
                }
                .padding([.top,.leading], 10)
                HStack {
                    SkimmerEffectBox()
                        .frame(width:100,height: 10)
                        .cornerRadius(5)
                    Spacer()
                    SkimmerEffectBox()
                        .frame(width:50,height: 10)
                        .cornerRadius(5)
                }
                .padding(.top, 10)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { _ in
                            ProductSkimmer()
                        }
                    }
                    .frame(height: 340)
                }
                .padding(.top, -10)
                HStack {
                    SkimmerEffectBox()
                        .frame(width:100,height: 10)
                        .cornerRadius(5)
                    Spacer()
                    SkimmerEffectBox()
                        .frame(width:50,height: 10)
                        .cornerRadius(5)
                }
                .padding(.top, -10)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { _ in
                            ProductSkimmer()
                        }
                    }
                    .frame(height: 340)
                }
                .padding(.top, -20)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
        }
    }
}


