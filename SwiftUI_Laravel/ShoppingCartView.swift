//
//  ShoppingCartView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 16/3/25.
//

import SwiftUI

struct ShoppingCartView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView{
                    ForEach(1 ... 10, id: \.self){_ in
                        CartView()
                    }
                }
                HStack{
                    Text("Total: ")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color(white:0.2))
                    Spacer()
                    Text("$300.00")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .bold()
                }.padding(.horizontal, 18)
                Button(action: {
                    // Handle logout action
                }) {
                    Text("Checkout Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle(Text("Shopping Carts"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ShoppingCartView()
}
