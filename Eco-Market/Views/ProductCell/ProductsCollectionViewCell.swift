//
//  ProductsCollectionViewCell.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    var product: ProductModel?
    
    private lazy var productCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1).cgColor
        return view
    }()
    
    private lazy var productImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var productNameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.numberOfLines = 0
        name.lineBreakMode = .byCharWrapping
        name.textAlignment = .left
        name.font = .systemFont(ofSize: 14, weight: .medium)
        return name
    }()
    
    private lazy var productPrice: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = ColorConstants.mainGreen
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Добавить", for: .normal)
//        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductsCollectionViewCell {
    private func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(productCard)
        productCard.addSubview(productImage)
        productCard.addSubview(productNameLabel)
        productCard.addSubview(productPrice)
        productCard.addSubview(addButton)
    }
    
    private func setupConstraints() {
        productCard.snp.makeConstraints {
            $0.height.equalTo(228)
            $0.width.equalTo(166)
        }
        
        productImage.snp.makeConstraints {
            $0.top.equalTo(productCard.snp.bottom).offset(4)
            $0.left.equalTo(productCard.snp.right).offset(4)
            $0.right.equalTo(productCard.snp.left).offset(-4)
            $0.height.equalTo(96)
            $0.width.equalTo(158)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImage.snp.bottom).offset(4)
            $0.left.equalTo(productCard.snp.right).offset(4)
            $0.right.equalTo(productCard.snp.left).offset(-4)
            $0.height.equalTo(34)
            $0.width.equalTo(158)
        }
        
        productPrice.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(24)
            $0.left.equalTo(productCard.snp.right).offset(4)
            $0.right.equalTo(productCard.snp.left).offset(-144)
            $0.height.equalTo(14)
            $0.width.equalTo(38)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(54)  // ?
            $0.width.equalTo(158)
            $0.height.equalTo(32)
            $0.left.equalTo(productCard.snp.right).offset(4)
            $0.right.equalTo(productCard.snp.left).offset(-144)
            $0.bottom.equalTo(productCard.snp.bottom).offset(-4)
        }
    }
    
     func displayInfo(product: ProductModel) {
         self.product = product
         
         if let name = product.title {
             productNameLabel.text = name
         } else {
             productNameLabel.text = "Название"
         }
         
         if let price = product.price {
             productPrice.text = String("\(price)сом")
         } else {
             productPrice.text = "Цена"
         }
         
         if let productImageURL = product.image,
            let imageURL = URL(string: productImageURL) {
             productImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"))
         } else {
             productImage.image = UIImage(named: "placeholderImage")
         }
    }
}
