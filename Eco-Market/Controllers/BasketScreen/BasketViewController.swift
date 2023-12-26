//
//  BasketViewController.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit

class BasketViewController: UIViewController {

    private lazy var clearLabel: UILabel = {
        var label = UILabel()
        label.text = "Oчистить"
        label.textColor = .red
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var basketLabel: UILabel = {
        var label = UILabel()
        label.text = "Корзина"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension BasketViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        view.addSubview(clearLabel)
        view.addSubview(basketLabel)
    }
    
    private func setUpConstraints() {
        clearLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(57)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(82)
            $0.height.equalTo(18)
        }
        
        basketLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(57)
            $0.width.equalTo(80)
            $0.height.equalTo(18)
        }
    }
}
