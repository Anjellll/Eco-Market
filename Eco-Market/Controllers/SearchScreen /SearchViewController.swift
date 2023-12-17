//
//  SearchViewController.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    var selectedProduct: ProductCategoryModel?
    
    private var categoryData = [
        CategoryModel(name: "Все"),
        CategoryModel(name: "Фрукты"),
        CategoryModel(name: "Сухофрукты"),
        CategoryModel(name: "Овощи"),
        CategoryModel(name: "Зелень"),
        CategoryModel(name: "Чай кофе"),
        CategoryModel(name: "Молочные продукты")
    ]
    
    private var allProductsData = [ProductModel]()
    
    private let searchBar: UISearchBar = {  // must have clean the code
        let search = UISearchBar()
        search.searchTextField.placeholder = "Быстрый поиск"
        search.searchTextField.textAlignment = .left
        search.searchTextField.font = .systemFont(ofSize: 16, weight: .medium)
        search.barTintColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        search.tintColor = .lightGray
        search.searchTextField.textColor = .black
        search.searchTextField.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        search.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        search.layer.cornerRadius = 16
        search.clipsToBounds = true
        let attributes: [NSAttributedString.Key: Any] = [  // maybe delete
            .foregroundColor: UIColor(red: 0.824, green: 0.82, blue: 0.835, alpha: 1),
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        return search
    }()
    
    private lazy var  categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
//        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    private let productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Продукты"
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
}

extension SearchViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
        configureCollectionViews() // тебе надо дать размеры для коллекции!!!
    }
    
    private func setUpSubviews() {
        view.addSubview(searchBar)
        view.addSubview(categoryCollectionView)
        view.addSubview(productsCollectionView)
    }
    
    private func setUpConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
            $0.width.equalTo(343)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
//            make.width.equalTo(UIScreen.main.bounds.width) // ?
            $0.height.equalTo(28)
            $0.width.equalTo(69)
            $0.leading.trailing.equalToSuperview()
        }
        
        productsCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(15)
            $0.height.equalTo(228)
            $0.width.equalTo(166)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionViews() {
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        productsCollectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.reuseIdentifier)
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
            for: indexPath) as? CategoryCollectionViewCell else { fatalError() }
        
        let categoryProduct = categoryData[indexPath.row]
        cell.displayInfo(product: categoryProduct)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: -  UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        
    }
}
