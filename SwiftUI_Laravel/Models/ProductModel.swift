//
//  ProductResponse.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 9/6/25.
//

import Foundation

struct ProductResponse: Codable {
    let status: Bool
    let rawProducts: [RawProduct]

    enum CodingKeys: String, CodingKey {
        case status
        case rawProducts = "products"
    }

    func toProducts() -> [Product] {
        rawProducts.compactMap { try? $0.toProduct() }
    }
}

struct RawProduct: Codable {
    let id: Int
    let product_name: String
    let description: String
    let price: String
    let discount: String
    let stock_quantity: Int
    let status: Int
    let main_image_url: String
    let collection_image_url: String
    let category_id: Int?
    let created_at: String
    let updated_at: String
    let category: Categorys?

    func toProduct() throws -> Product {
        let collectionImageData = collection_image_url.data(using: .utf8) ?? Data()
        let decodedImages = try JSONDecoder().decode([String].self, from: collectionImageData)
        return Product(
            id: id,
            productName: product_name,
            description: description,
            price: price,
            discount: discount,
            stockQuantity: stock_quantity,
            status: status,
            mainImageURL: main_image_url,
            collectionImageURL: decodedImages,
            categoryID: category_id ?? 0,
            createdAt: created_at,
            updatedAt: updated_at,
            category: category
        )
    }
}

struct Product: Codable, Identifiable {
    let id: Int
    let productName: String
    let description: String
    let price: String
    let discount: String
    let stockQuantity: Int
    let status: Int
    let mainImageURL: String
    let collectionImageURL: [String]
    let categoryID: Int
    let createdAt: String
    let updatedAt: String
    let category: Categorys?

    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case description
        case price
        case discount
        case stockQuantity = "stock_quantity"
        case status
        case mainImageURL = "main_image_url"
        case collectionImageURL = "collection_image_url"
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category
    }

    // Custom decoding for collectionImageURL to convert the string representation of the array
    init(
        id: Int,
        productName: String,
        description: String,
        price: String,
        discount: String,
        stockQuantity: Int,
        status: Int,
        mainImageURL: String,
        collectionImageURL: [String],
        categoryID: Int,
        createdAt: String,
        updatedAt: String,
        category: Categorys?
    ) {
        self.id = id
        self.productName = productName
        self.description = description
        self.price = price
        self.discount = discount
        self.stockQuantity = stockQuantity
        self.status = status
        self.mainImageURL = mainImageURL
        self.collectionImageURL = collectionImageURL
        self.categoryID = categoryID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.category = category
    }
}
