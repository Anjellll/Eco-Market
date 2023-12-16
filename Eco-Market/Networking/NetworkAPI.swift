//
//  NetworkAPI.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit
import Alamofire

enum NetworkAPI {
    
    // MARK: - GET
    case getProductCategoryList
    case getProductList
    case getOrderList
    
    // MARK: - POST
    case postOrderCreate
    
    var host: String {
        "neobook.online/ecobak"
    }
    
    var path: String {
        switch self {
        case .getProductList:
            return "/product-list/"
        case .getProductCategoryList:
            return "/product-category-list/"
        case .getOrderList:
            return "/order-list/"
        case .postOrderCreate:
            return "/order-create/"
        }
    }
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        return components
    }
}

