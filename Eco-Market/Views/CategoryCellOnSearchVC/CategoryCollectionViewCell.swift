//
//  CategoryCollectionViewCell.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    private lazy var categoryLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1)
        label.textAlignment = .center
//        label.backgroundColor = .green
        label.layer.cornerRadius = 28 / 2
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1).cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CategoryCollectionViewCell {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        addSubview(categoryLabel)
    }
    
    private func setUpConstraints() {
        categoryLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(5)
            maker.right.equalToSuperview().offset(-5)
            maker.height.equalTo(28)
        }
    }
    
    func displayInfo(product: CategoryModel) {
        categoryLabel.text = product.name
    }
}
