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
    
    func addToBasket(product: BasketModel) {
        do {
            try realm.write {
                if realm.object(ofType: BasketModel.self, forPrimaryKey: product.id) == nil {
                    realm.add(product)
                } else {
                    print("🌈Product is already in the basket.")
                }
            }
        } catch {
            print("🛑Error saving product to Realm: \(error.localizedDescription)")
        }
    }

    
    func getBasketProducts() -> Results<BasketModel> {
        return realm.objects(BasketModel.self)
    }
    
    func clearBasket() {
        do {
            try realm.write {
                realm.deleteAll()
            }
            print("Basket cleared successfully")
            let basketProducts = getBasketProducts()
            print("Remaining products in the basket: \(basketProducts.count)")
        } catch {
            print("Error clearing basket: \(error.localizedDescription)")
        }
    }
    
    // В BasketManager
    func printBasketCount() {
        let basketProducts = getBasketProducts()
        print("Number of products in the basket: \(basketProducts.count)")
    }

    
}
