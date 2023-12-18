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
        label.textColor = UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1)
        label.textAlignment = .center
        label.layer.cornerRadius = 28 / 2
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1).cgColor
        label.clipsToBounds = true // Important to clip content to the rounded corners
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateCellState()
        }
    }
    
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
        layoutSubviews()
        updateCellState()
    }
    
    private func setUpSubviews() {
        addSubview(categoryLabel)
    }
    
    private func setUpConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(2)
            $0.right.equalToSuperview().offset(-2)
            $0.height.equalTo(28)
        }
    }
    
    private func updateCellState() {
        if isSelected {
            categoryLabel.backgroundColor = ColorConstants.mainGreen
            categoryLabel.textColor = .white
            categoryLabel.layer.cornerRadius = 28 / 2
            categoryLabel.layer.borderWidth = 0 
            categoryLabel.layer.borderColor = nil
        } else {
            categoryLabel.backgroundColor = .clear
            categoryLabel.textColor = UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1)
            categoryLabel.layer.cornerRadius = 28 / 2
            categoryLabel.layer.borderWidth = 1
            categoryLabel.layer.borderColor = UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1).cgColor
        }
    }
    
    func displayInfo(product: CategoryModel) {
        categoryLabel.text = product.name
    
    }
}
