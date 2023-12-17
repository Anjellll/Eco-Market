//
//  ProductCategoryCollectionViewCell.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit
import Kingfisher

class ProductCategoryCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    var productCategory: ProductCategoryModel?
    
    private lazy var categoryImage: UIImageView! = {
        var productImage = UIImageView()
        productImage.contentMode = .scaleAspectFill
        productImage.layer.cornerRadius = 12
        productImage.clipsToBounds = true
        return productImage
    }()
    
    private lazy var categoryLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
        addGradientLayer()
    }
    
    private func setUpSubviews() {
        addSubview(categoryImage)
        categoryImage.addSubview(categoryLabel)
    }
    
    private func setUpConstraints() {
        categoryImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(40)
            $0.width.equalTo(142)
        }
    }
    
    private func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = 12
        
        gradientLayer.bounds = categoryImage.bounds
        gradientLayer.position = CGPoint(x: categoryImage.bounds.midX, y: categoryImage.bounds.midY)
        
        categoryImage.layer.addSublayer(gradientLayer)
        categoryImage.layer.masksToBounds = true
    }

    func displayInfo(product: ProductCategoryModel) {
        self.productCategory = product
        
        if let categoryName = product.name {
            categoryLabel.text = categoryName
        } else {
            categoryLabel.text = "N/A"
        }
        
        if let categoryImageURL = product.image,
           let imageURL = URL(string: categoryImageURL) {
            categoryImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"))
        } else {
            categoryImage.image = UIImage(named: "placeholderImage")
        }
    }
}

