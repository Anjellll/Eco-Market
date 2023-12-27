//
//  BasketViewController.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit

class BasketViewController: UIViewController {

    private var productData: [ProductModel] = []
    private var basketProducts: [BasketModel] = []
    
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
    
    private lazy var  basketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                setUpUI()
        fetchProduct()
        
        // Получаем продукты из корзины
        basketProducts = BasketManager.shared.getBasketProducts()
        
        print("Basket products in viewDidLoad: \(basketProducts)")
    }
    
    func fetchProduct() {
        NetworkLayer.shared.fetchProduct(apiType: .getProductList) {  [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self.productData = product
                    self.basketCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching product categories: \(error)")
                }
            }
        }
    }
}

extension BasketViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
//        configureCollectionViews()
    }
    
    private func setUpSubviews() {
        view.addSubview(clearLabel)
        view.addSubview(basketLabel)
        view.addSubview(basketCollectionView)
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
        
        basketCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.height.equalTo(94)
            $0.width.equalTo(343)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionViews() {
        basketCollectionView.register(BasketCollectionViewCell.self, forCellWithReuseIdentifier: BasketCollectionViewCell.reuseIdentifier)
        basketCollectionView.delegate = self
        basketCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = basketCollectionView.dequeueReusableCell(
            withReuseIdentifier: BasketCollectionViewCell.reuseIdentifier,
            for: indexPath) as? BasketCollectionViewCell else { fatalError() }
        
        let product = productData[indexPath.row]
        cell.displayInfo(product: product)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BasketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 94)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
}
