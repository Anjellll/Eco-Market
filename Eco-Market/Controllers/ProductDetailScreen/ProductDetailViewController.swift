//
//  ProductDetailViewController.swift
//  Eco-Market
//
//  Created by anjella on 21/12/23.
//

import UIKit
import Kingfisher

protocol ProductDetailDelegate: AnyObject {
    func didAddToCart(product: ProductModel, quantity: Int)
    func removeFromCart(product: ProductModel, quantity: Int)
}

class ProductDetailViewController: UIViewController {
    
    weak var delegate: ProductDetailDelegate?

    var selectedProduct: ProductModel? {
        didSet {
            if let priceString = selectedProduct?.price, let price = Double(priceString) {
                productPriceValue = price
            }
        }
    }
    
    private var productPriceValue: Double = 0.0 {
        didSet {
            productPrice.text = "\(productPriceValue)c"
        }
    }

    
    override var isEditing: Bool {
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
        name.font = .systemFont(ofSize: 24, weight: .bold)
        return name
    }()
    
    private lazy var productDescription: UILabel = {
        let description = UILabel()
        description.textColor =  UIColor(red: 0.673, green: 0.671, blue: 0.679, alpha: 1)
        description.numberOfLines = 0
        description.lineBreakMode = .byWordWrapping
        description.textAlignment = .left
        description.font = .systemFont(ofSize: 16, weight: .regular)
        return description
    }()
    
    private lazy var productPrice: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = ColorConstants.mainGreen
        label.font = .systemFont(ofSize: 24, weight: .bold)
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
    
    private lazy var productSumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let product = selectedProduct {   // clean the code
            if let productImageURL = product.image,
               let imageURL = URL(string: productImageURL) {
                productImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"))
            } else {
                productImage.image = UIImage(named: "placeholderImage")
            }
            productNameLabel.text = product.title
            if let price = product.price {
                productPrice.text = String("\(price)с")
            } else {
                productPrice.text = "Цена"
            }
            productDescription.text = product.description
        }
    }
}

extension ProductDetailViewController {
    private func setupUI() {
        setupSubviews()
        setupConstraints()
        updateUI()
        updateProductSumLabel()
    }
    
    private func setupSubviews() {
        view.addSubview(productCard)
        productCard.addSubview(productImage)
        productCard.addSubview(productNameLabel)
        productCard.addSubview(productPrice)
        productCard.addSubview(productDescription)
        view.addSubview(addButton)
        view.addSubview(plusButton)
        view.addSubview(productCountLabel)
        view.addSubview(minusButton)
        view.addSubview(productSumLabel)
    }
    
    private func setupConstraints() {
        productCard.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(432)
            $0.width.equalTo(375)
        }
        
        productImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(190)
            $0.width.equalTo(343)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImage.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
            $0.width.equalTo(343)
        }
        
        productPrice.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(28)
            $0.width.equalTo(343)
        }
        
        productDescription.snp.makeConstraints {
            $0.top.equalTo(productPrice.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(76)
            $0.width.equalTo(343)
        }
        
        addButton.snp.makeConstraints {
            $0.width.equalTo(343)
            $0.height.equalTo(54)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        productSumLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-38)
        }
        
        minusButton.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
            $0.right.equalTo(productCountLabel.snp.left).offset(-35)
            $0.bottom.equalToSuperview().offset(-36)
        }
    
        productCountLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(18)
            $0.right.equalTo(plusButton.snp.left).offset(-35)
            $0.bottom.equalToSuperview().offset(-43)
        }
        
        plusButton.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-36)
        }
    }
    
    private func updateUI() {
        plusButton.isHidden = !isEditing
        productCountLabel.isHidden = !isEditing
        minusButton.isHidden = !isEditing
        addButton.isHidden = isEditing
        productSumLabel.isHidden = !isEditing
        
        plusButton.isEnabled = itemCount < 50
        updateProductSumLabel()
    }

    private func updateProductSumLabel() {
        let totalSum = Double(itemCount) * productPriceValue
        productSumLabel.text = "\(totalSum)c"
    }
    
    @objc func addButtonTapped() {
        isEditing = !isEditing
        itemCount = 1
        updateUI()
        
        if let selectedProduct = selectedProduct {
            delegate?.didAddToCart(product: selectedProduct, quantity: itemCount)
        }
    }
    
    @objc func plusButtonTapped() {
        if itemCount < 50 {
            itemCount += 1
            plusButton.isEnabled = itemCount < 50
        }

        if let selectedProduct = selectedProduct {
            delegate?.didAddToCart(product: selectedProduct, quantity: 1)
        }

        updateUI()
    }

    @objc func minusButtonTapped() {
        if itemCount > 1 {
            itemCount -= 1
            if let product = selectedProduct {
                delegate?.removeFromCart(product: product, quantity: 1) // Уменьшаем на 1, поскольку нажали кнопку "-"
            }
        } else if itemCount == 1 {
            itemCount -= 1
            isEditing = false
            if let product = selectedProduct {
                delegate?.removeFromCart(product: product, quantity: 1) // Уменьшаем на 1, так как количество станет 0
            }
        }

        updateUI()
    }

}
