//
//  ProfileView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 16/3/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
        }
        .onAppear {
            hideTabBar()
        }
    }
    
    func hideTabBar() {
        if let tabBarController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
}

#Preview {
    ProfileView()
}
