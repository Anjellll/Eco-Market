//
//  BasketCollectionViewCell.swift
//  Eco-Market
//
//  Created by anjella on 26/12/23.
//

import UIKit

class BasketCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
 
    var product: ProductModel?
    
    private lazy var productImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var productNameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
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
    
    private lazy var piecePriceLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.673, green: 0.671, blue: 0.679, alpha: 1)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var deleteImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.image = UIImage(named: "deleteIcon")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasketCollectionViewCell {
    private func setupUI() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        addSubview(productImage)
        addSubview(productNameLabel)
        addSubview(productPrice)
        addSubview(piecePriceLabel)
        addSubview(deleteImage)
    }
    
    private func setUpConstraints() {
        productImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
            $0.height.equalTo(86)
            $0.width.equalTo(98)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalTo(productImage.snp.right).offset(8)
            $0.height.equalTo(17)
            $0.width.equalTo(158)
        }
        
        piecePriceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(4)
            $0.left.equalTo(productImage.snp.right).offset(8)
            $0.height.equalTo(17)
            $0.width.equalTo(158)
        }
        
        productPrice.snp.makeConstraints {
//            $0.top.equalTo(piecePriceLabel.snp.bottom).offset(29)
            $0.left.equalTo(productImage.snp.right).offset(8)
            $0.height.equalTo(14)
            $0.width.equalTo(90)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        deleteImage.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(8)
            $0.left.equalToSuperview().offset(6)
            $0.height.equalTo(32)
            $0.width.equalTo(32)
            $0.bottom.equalToSuperview().offset(-6)
        }
    }
    
    func displayInfo(product: ProductModel) {
        self.product = product
        
        if let productName = product.title {
            productNameLabel.text = productName
        } else {
            productNameLabel.text = "Название"
        }
        
        if let price = product.price {
            productPrice.text = String("\(price)с")
        } else {
            productPrice.text = "Цена"
        }
        
        if let piece = product.price {
            piecePriceLabel.text = String("Цена \(piece) с за шт")
        } else {
            piecePriceLabel.text = "Штук"
        }
        
        if let productImageURL = product.image,
           let imageURL = URL(string: productImageURL) {
            productImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"))
        } else {
            productImage.image = UIImage(named: "placeholderImage")
        }
    }
}

