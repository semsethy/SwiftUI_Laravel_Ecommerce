//
//  Category.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 9/6/25.
//


struct Category: Identifiable, Codable {
    var id: Int
    var title: String
    var image: String?
    var status: Int
}

struct CategoryResponse: Codable {
    var status: Bool
    var categories: [Category]
}

struct Categorys: Codable {
    let id: Int
    let title: String
    let image: String
    let status: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
