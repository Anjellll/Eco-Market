//
//  BasketManager.swift
//  Eco-Market
//
//  Created by anjella on 27/12/23.
//

import RealmSwift

class BasketManager {
    static let shared = BasketManager()
    
    private let realm = try! Realm()
    
    func addToBasket(product: ProductModel) {
        let basketProduct = BasketModel()
        basketProduct.id = product.id ?? 0
        basketProduct.title = product.title ?? ""
        basketProduct.image = product.image ?? ""
        basketProduct.quantity = 1
        basketProduct.price = product.price ?? ""
        
        try! realm.write {
            realm.add(basketProduct, update: .modified)
        }
        
        print("Product added to basket: \(basketProduct.title)")
    }
    
    func getBasketProducts() -> [BasketModel] {
        let basketProducts = realm.objects(BasketModel.self)
        let productsArray = Array(basketProducts)
        print("Basket products: \(productsArray)")
        return productsArray
    }
}
