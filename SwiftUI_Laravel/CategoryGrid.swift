//
//  CategoryGrid.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 15/3/25.
//

import SwiftUI

struct CategoryGrid: View {
    let item: Category
    var body: some View {
        NavigationLink(destination: ProductDetailView()){
            VStack(spacing: 10){
                if let imageUrl = item.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .background(Color(white: 0.9))
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .background(Color(white: 0.9))
                            .clipShape(Circle())
                    }
                }
                    
                Text(item.title)
                    .font(.subheadline)
                    .foregroundColor(.init(uiColor: .darkGray))
                    .frame(width: 85)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    CategoryGrid(item: .init(id: 1, title: "", image: "", status: 1))
}
