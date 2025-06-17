//
//  SlideshowResponse.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 9/6/25.
//


struct SlideshowResponse: Codable {
    let status: Bool
    let slideshows: [Slideshows]
}

struct Slideshows: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let caption: String
    let description: String
    let link: String
    let status: Int
    let category: Category?
}