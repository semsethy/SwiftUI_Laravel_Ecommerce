//
//  SwiftUI_LaravelApp.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 8/3/25.
//

import SwiftUI
import UIKit

@main
struct SwiftUI_LaravelApp: App {
    @StateObject var cartViewModel = CartViewModel()
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environmentObject(cartViewModel)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
