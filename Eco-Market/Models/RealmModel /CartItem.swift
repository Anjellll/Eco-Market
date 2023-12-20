//
//  CartItem.swift
//  Eco-Market
//
//  Created by anjella on 20/12/23.
//

import RealmSwift

class CartItem: Object {
    @objc dynamic var productId: Int = 0
    @objc dynamic var quantity: Int = 0
}
