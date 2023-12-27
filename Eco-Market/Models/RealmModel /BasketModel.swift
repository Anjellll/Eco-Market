//
//  BasketModel.swift
//  Eco-Market
//
//  Created by anjella on 27/12/23.
//

import RealmSwift

class BasketModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var category: Int = 0
    @objc dynamic var image: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var price: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
 
