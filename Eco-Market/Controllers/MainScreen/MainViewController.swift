//
//  MainViewController.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private var categoryProductData: [ProductCategoryModel] = []
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Эко Маркет"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var  categoryCollectionView: UICollectionView = {
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
        fetchcategory()
    }
    
    func fetchcategory() {
        NetworkLayer.shared.fetchProductCategory(apiType: .getProductCategoryList) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let categoryData):
                    self.categoryProductData = categoryData
                    self.categoryCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching product categories: \(error)")
                }
            }
        }
    }
}

extension MainViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
        configureCollectionViews()
        congigureNavigationBar()
    }
    
    private func setUpSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(categoryCollectionView)
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.left.equalToSuperview().offset(119)
            $0.right.equalToSuperview().offset(-118)
            $0.width.equalTo(138)
            $0.height.equalTo(24)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(166)
            $0.height.equalTo(180)
        }
    }
    
    private func congigureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func configureCollectionViews() {
        categoryCollectionView.register(ProductCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ProductCategoryCollectionViewCell.reuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryProductData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCategoryCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ProductCategoryCollectionViewCell else { fatalError() }
        
        let product = categoryProductData[indexPath.row]
        cell.displayInfo(product: product)
        
        // Добавляем обработчик нажатия на ячейку
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }

    @objc func didTapCell(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? ProductCategoryCollectionViewCell,
              let indexPath = categoryCollectionView.indexPath(for: cell) else {
            return
        }
        
        let selectedProduct = categoryProductData[indexPath.row]
        let searchViewController = SearchViewController()
        searchViewController.selectedProduct = selectedProduct
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let totalSpacing = 2 * 16 + max(0, numberOfColumns - 1) * 11
        let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        let cellHeight: CGFloat = 180

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
}
