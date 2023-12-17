//
//  ReuseIdentifying.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

