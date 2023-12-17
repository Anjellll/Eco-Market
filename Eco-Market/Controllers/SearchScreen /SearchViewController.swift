//
//  SearchViewController.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    var selectedProduct: ProductCategoryModel?
    
    private let searchBar: UISearchBar = {
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
    }
    
    private func setUpSubviews() {
        view.addSubview(searchBar)
    }
    
    private func setUpConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
            $0.width.equalTo(343)
        }
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
