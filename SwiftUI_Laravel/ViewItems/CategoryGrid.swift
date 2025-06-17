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
        NavigationLink(destination: ProductGridList(type: item.title)){
            VStack(spacing: 10){
                if let imageUrl = item.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Rectangle())
                    } placeholder: {
//                        Rectangle()
                        SkimmerEffectBox()
                               .frame(width: 60, height: 60)
                               .clipShape(Circle())
                            
                    }
                }
                    
                if !item.title.isEmpty {
                    Text(item.title)
                        .font(.subheadline)
                        .foregroundColor(.init(uiColor: .darkGray))
                        .frame(width: 85)
                        .lineLimit(1)
                } else {
                    SkimmerEffectBox()
                            .frame(width: 85, height: 10)
                    
                }
            }
        }
    }
}

#Preview {
    CategoryGrid(item: .init(id: 1, title: "dsdsds", image: "semsethy", status: 1))
}


struct CategorySkimmer: View {
    var body: some View {
        VStack{
            SkimmerEffectBox()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            SkimmerEffectBox()
                .frame(width: 85, height: 10)
        }
    }
}
