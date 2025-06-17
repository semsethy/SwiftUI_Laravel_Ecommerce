//
//  CartItem.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 9/6/25.
//


struct CartItem: Codable, Identifiable {
    let id: Int
    let user_id: Int
    let product_id: Int
    let quantity: Int
    let created_at: String
    let updated_at: String
    let product: RawProduct

    enum CodingKeys: String, CodingKey {
        case id, user_id, product_id, quantity, created_at, updated_at, product
    }

    func toProcessedItem() -> ProcessedCartItem? {
        guard let processedProduct = try? product.toProduct() else { return nil }
        return ProcessedCartItem(
            id: id,
            product_id: product_id,
            quantity: quantity,
            product: processedProduct
        )
    }
}
struct ProcessedCartItem: Identifiable {
    let id: Int
    let product_id: Int
    let quantity: Int
    let product: Product
}
struct CartResponse: Codable {
    let cart: [CartItem]
    
}

struct CartCountResponse: Decodable {
    let count: String

    var countValue: Int {
        return Int(count) ?? 0
    }
}