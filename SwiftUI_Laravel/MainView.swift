import SwiftUI

struct MainView: View {
    @State private var selection = 1

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(1)
                
                ShoppingCartView()
                    .tabItem {
                        Label("Shopping Cart", systemImage: "cart.fill")
                    }
                    .tag(2)
                
                WishListView()
                    .tabItem {
                        Label("Wish List", systemImage: "heart")
                    }
                    .tag(3)
                
                ProfileView()
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

#Preview {
    MainView()
}
