import SwiftUI

struct MainView: View {
    @Binding var selection: Int
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    TabView(selection: $selection) {
                        HomeView()
                        .navigationBarTitleDisplayMode(.inline)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(1)
                        NavigationView {
                            ShoppingCartView()
                        }
                        .tabItem {
                            Label("Shopping Cart", systemImage: "cart.fill")
                        }
                        .tag(2)
                        NavigationView {
                            WishListView()
                        }
                        .tabItem {
                            Label("Wish List", systemImage: "heart")
                        }
                        .tag(3)
                        NavigationView {
                            ProfileView()
                        }
                        .tabItem {
                            Label("Profile", systemImage: "person.circle.fill")
                        }
                        .tag(4)
                    }
                    .accentColor(.cyan)
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.systemGray6
                        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
                    }
                }
            }
        }
    }
}

#Preview {
    MainView(selection: .constant(1))
        .environmentObject(CartViewModel())
}

