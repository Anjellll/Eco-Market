//
//  ProductModel.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import Foundation

// MARK: - ProductModel
struct ProductModel: Codable {
    let id: Int?
    let title, description: String?
    let category: Int?
    let image: String?
    var quantity: Int?
    let price: String?
}
