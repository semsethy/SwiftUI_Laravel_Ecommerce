import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var tabSelection = 1
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var wishlistViewModel = WishlistViewModel()

    var body: some View {
        if isLoggedIn {
            MainView(selection: $tabSelection)
                .environmentObject(cartViewModel)
                .environmentObject(wishlistViewModel)
        } else {
            LoginView(onLoginSuccess: {
                tabSelection = 1
            })
        }
    }
}
