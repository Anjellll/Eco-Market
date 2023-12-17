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
//        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    private let productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .red
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
        fetchProduct()
    }
    
    func fetchProduct() {
        NetworkLayer.shared.fetchProduct(apiType: .getProductList) {  [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self.allProductsData = product
                    self.productsCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching product categories: \(error)")
                }
            }
        }
    }
}

extension SearchViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
        configureCollectionViews()
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
            $0.height.equalTo(28)
            $0.width.equalTo(69)
            $0.leading.trailing.equalToSuperview()
        }
        
        productsCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
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
        if collectionView == categoryCollectionView {
            return categoryData.count
        } else if collectionView == productsCollectionView {
            return allProductsData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = categoryCollectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
                for: indexPath) as? CategoryCollectionViewCell else { fatalError() }
            
            let categoryProduct = categoryData[indexPath.row]
            cell.displayInfo(product: categoryProduct)
            return cell
        } else if collectionView == productsCollectionView {
            guard let cell = productsCollectionView.dequeueReusableCell(
                withReuseIdentifier: ProductsCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ProductsCollectionViewCell else { fatalError() }
            
            let product = allProductsData[indexPath.row]
            cell.displayInfo(product: product)
            return cell
        }
        fatalError("Unexpected collection view")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
            
        } else if collectionView == productsCollectionView {
            let numberOfColumns: CGFloat = 2
            let totalSpacing = 2 * 16 + max(0, numberOfColumns - 1) * 11
            let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
            let cellHeight: CGFloat = 228

            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { // change num
        if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        } else if collectionView == productsCollectionView {
        
            return UIEdgeInsets(top: 19, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return 8
        } else if collectionView == productsCollectionView {
            return 11
        }
        return 0
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
