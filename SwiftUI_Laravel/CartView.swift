//
//  CartView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 16/3/25.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        HStack{
            Image("applewatch")
                .resizable()
                .scaledToFill()
                .frame(width: 100,height: 100)
                .background(Color(white: 1))
                .cornerRadius(10)
            
            VStack(alignment: .leading,spacing: 5){
                Text("Apple Watch Series 6")
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(Color(white:0.2))
                Text("Watch")
                    .font(.subheadline)
                    .lineLimit(1)
                HStack{
                    Text("$299")
                        .font(.headline)
                        .foregroundColor(.red)
                        .lineLimit(1)
                    Spacer()
                    HStack(spacing: 18){
                        Button {
                            
                        } label: {
                            Text("-")
                                .foregroundColor(Color(white: 0.2))
                                .font(.system(size: 25))
                        }
                        Text("1")
                        Button {
                            
                        } label: {
                            Text("+")                                .foregroundColor(Color(white: 0.2))
                                .font(.system(size: 20))
                        }

                    }
                    .padding([.top,.bottom],3)
                    .padding([.leading,.trailing],18)
                    .background(Color(white: 1))
                    .cornerRadius(5)
                    
                }
                .padding(.bottom,-8)
            }
        }
        .padding(10)
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .padding(.horizontal,20)
        .padding(.vertical,3)
        
    }
}

#Preview {
    CartView()
}
