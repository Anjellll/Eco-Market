//
//  BasketViewController.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit

class BasketViewController: UIViewController {

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
    
    private lazy var placeOrderButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Оформить заказ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = ColorConstants.mainGreen
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(placeOrderButtonTapped), for: .touchUpInside)
        return button
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
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
}

extension BasketViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
        configureCollectionViews()
        updateUI()
    }
    
    private func setUpSubviews() {
        view.addSubview(clearLabel)
        view.addSubview(basketLabel)
        view.addSubview(basketCollectionView)
        view.addSubview(placeOrderButton)
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
        
        placeOrderButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.width.equalTo(343)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func configureCollectionViews() {
        basketCollectionView.register(BasketCollectionViewCell.self, forCellWithReuseIdentifier: BasketCollectionViewCell.reuseIdentifier)
        basketCollectionView.delegate = self
        basketCollectionView.dataSource = self
    }
    
    func updateUI() {
        basketProducts = BasketManager.shared.getBasketProducts()
        print("Basket products in viewDidLoad: \(basketProducts)")
        
        basketCollectionView.reloadData()
    }
    
    @objc private func placeOrderButtonTapped() {
        let storyViewController = OrderViewController()
        
        navigationController?.pushViewController(storyViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        basketProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = basketCollectionView.dequeueReusableCell(
            withReuseIdentifier: BasketCollectionViewCell.reuseIdentifier,
            for: indexPath) as? BasketCollectionViewCell else { fatalError() }
        
        cell.product = basketProducts[indexPath.item]
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
