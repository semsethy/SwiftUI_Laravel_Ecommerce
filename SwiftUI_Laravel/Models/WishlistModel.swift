//
//  WishlistResponse.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 9/6/25.
//


struct WishlistResponse: Codable {
    let status: Bool
    let wishlist: [WishlistItem]
}

struct WishlistItem: Codable {
    let id: Int
    let product_id: Int
    let user_id: Int
    let created_at: String
    let updated_at: String
    let product: RawProduct
}

