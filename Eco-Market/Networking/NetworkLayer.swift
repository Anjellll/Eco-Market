//
//  NetworkLayer.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit
import Alamofire

final class NetworkLayer {

    static let shared = NetworkLayer()

    private init() { }
    
    func fetchProductCategory(apiType: NetworkAPI, completion: @escaping (Result<[ProductCategoryModel], Error>) -> Void) {
        let url = apiType.components.url!

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let productCategory = try JSONDecoder().decode([ProductCategoryModel].self, from: data)
                    completion(.success(productCategory))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

