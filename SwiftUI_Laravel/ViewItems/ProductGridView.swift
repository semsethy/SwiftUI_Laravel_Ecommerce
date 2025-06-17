//
//  ProductGridView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 11/4/25.
//

import SwiftUI

struct ProductGridView: View {
    @State private var isHearted = false
    let item: Product
    private let baseURL = "http://127.0.0.1:8000/"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("-30%")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .bold()
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())

                Spacer()

                Button {
                    isHearted.toggle()
                } label: {
                    Image(systemName: isHearted ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(10)
                        .foregroundColor(.gray)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding([.horizontal, .top], 10)

            // Product Image
            NavigationLink(destination: ProductDetailView(product: item).navigationBarHidden(true)) {
                let imageURL = baseURL + "storage/" + item.mainImageURL
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                } placeholder: {
                    Color.gray.opacity(0.2)
                        .frame(height: 120)
                        .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 15))
                }
            }

            // Product Details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                HStack(spacing: 5) {
                    Text(item.price)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.red)

                    Text("$1200")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .strikethrough()
                }

                HStack {
                    Text(item.category?.title ?? "kk")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Spacer()

                    Button {
                        // Add to cart action
                    } label: {
                        Image(systemName: "cart")
                            .foregroundColor(.gray)
                            .padding(6)
                            .background(Color(white: 0.95))
                            .cornerRadius(6)
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .clipShape(RoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 15))
        }
        .background(Color(white: 0.95))
        .cornerRadius(15)
    }
}
