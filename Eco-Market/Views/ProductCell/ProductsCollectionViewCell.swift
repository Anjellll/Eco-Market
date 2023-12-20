//
//  ProductsCollectionViewCell.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit
import Kingfisher
import RealmSwift

protocol ProductsCollectionViewCellDelegate: AnyObject {
    func updateTotalBasketAmount()
}

class ProductsCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    weak var delegate: ProductsCollectionViewCellDelegate?
    let realm = try! Realm()
    var product: ProductModel?
    
    private var isEditing: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    private var itemCount: Int = 0 {
        didSet {
            productCountLabel.text = "\(itemCount)"
        }
    }
    
    
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = ColorConstants.mainGreen
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = ColorConstants.mainGreen
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var productCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = ColorConstants.mainGreen
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductsCollectionViewCell {
    private func setupUI() {
        setupSubviews()
        setupConstraints()
        updateUI()
    }
    
    private func setupSubviews() {
        addSubview(productCard)
        productCard.addSubview(productImage)
        productCard.addSubview(productNameLabel)
        productCard.addSubview(productPrice)
        productCard.addSubview(addButton)
        productCard.addSubview(plusButton)
        productCard.addSubview(productCountLabel)
        productCard.addSubview(minusButton)
    }
    
    private func setupConstraints() {
        productCard.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(228)
            $0.width.equalTo(166)
        }
        
        productImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(4)
            $0.right.equalToSuperview().offset(-4)
            $0.height.equalTo(96)
            $0.width.equalTo(158)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(104)
            $0.left.equalToSuperview().offset(4)
            $0.right.equalToSuperview().offset(-4)
            $0.height.equalTo(34)
            $0.width.equalTo(158)
        }
        
        productPrice.snp.makeConstraints {
            $0.left.equalToSuperview().offset(4)
            $0.height.equalTo(14)
            $0.width.equalTo(80)
            $0.bottom.equalToSuperview().offset(-52)
        }
        
        addButton.snp.makeConstraints {
            $0.width.equalTo(158)
            $0.height.equalTo(32)
            $0.left.equalToSuperview().offset(4)
            $0.right.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        minusButton.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
            $0.left.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        productCountLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(18)
            $0.left.equalTo(minusButton.snp.right).offset(35)
            $0.bottom.equalToSuperview().offset(-11)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
            $0.right.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview().offset(-4)
        }
    }
    
    private func updateUI() {
        plusButton.isHidden = !isEditing
        productCountLabel.isHidden = !isEditing
        minusButton.isHidden = !isEditing
        addButton.isHidden = isEditing
        
        plusButton.isEnabled = itemCount < 50
        // Обновляем итоговую сумму в корзине через делегата
        delegate?.updateTotalBasketAmount()
    }
    
    @objc private func addButtonTapped() {
        guard let product = product else { return }
        addToCart(product: product)
        
        isEditing = !isEditing
        itemCount = 1
        
        updateUI()
    }
    
    @objc private func plusButtonTapped() {
        guard let product = product else { return }
        addToCart(product: product)
        
        if itemCount < 50 {
            itemCount += 1
            
            plusButton.isEnabled = itemCount < 50
        }
        updateUI()
    }
    
    
    @objc private func minusButtonTapped() {
        guard let product = product else { return }
        
        if itemCount > 1 {
            itemCount -= 1
            removeFromCart(product: product)
        } else if itemCount == 1 {
            itemCount -= 1
            removeFromCart(product: product)
            isEditing = false
        }
        // Обновляем UI после изменения состояния
        updateUI()
    }
    
    private func addToCart(product: ProductModel) {
        try! realm.write {
            if let existingCartItem = realm.objects(CartItem.self).filter("productId == %@", product.id).first {
                existingCartItem.quantity += 1
            } else {
                let newCartItem = CartItem()
                newCartItem.productId = product.id ?? 0
                newCartItem.quantity = 1
                realm.add(newCartItem)
            }
        }
        updateUI()
    }
    
    private func removeFromCart(product: ProductModel) {
        try! realm.write {
            if let existingCartItem = realm.objects(CartItem.self).filter("productId == %@", product.id).first {
                existingCartItem.quantity -= 1
                if existingCartItem.quantity == 0 {
                    realm.delete(existingCartItem)
                }
            }
        }
        updateUI()
    }
    
    
    func displayInfo(product: ProductModel) {
        self.product = product
        
        if let name = product.title {
            productNameLabel.text = name
        } else {
            productNameLabel.text = "Название"
        }
        
        if let price = product.price {
            productPrice.text = String("\(price)с")
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
