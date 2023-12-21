//
//  SearchViewController.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var selectedProduct: ProductCategoryModel?
    weak var delegate: ProductsCollectionViewCellDelegate?
    
    private var categoryData: [CategoryModel] = [
        CategoryModel(id: 0, name: "Все"),
        CategoryModel(id: 1, name: "Фрукты"),
        CategoryModel(id: 2, name: "Сухофрукты"),
        CategoryModel(id: 3, name: "Фрукты"),
        CategoryModel(id: 4, name: "Зелень"),
        CategoryModel(id: 5, name: "Чай кофе"),
        CategoryModel(id: 6, name: "Молочные продукты"),
    ]
    
    private var allProductsData = [ProductModel]()
    private var categoryProductData = [ProductModel]()
    private var cartData: [Int: Results<CartItem>] = [:]  // ?
    
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
    
    private lazy var noResultsView: NoResultView = {
        var view = NoResultView()
        return view
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
    
    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.layer.cornerRadius = 24
        let image = UIImage(named: "basket_icon2")
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ColorConstants.mainGreen
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 12,
                                              left: 16,
                                              bottom: 12,
                                              right: 124)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Продукты"
        searchBar.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
        fetchProduct()
        updateTotalBasketAmount()
        resetBasket()   // -
    }
    
    
    func fetchProduct() {
        NetworkLayer.shared.fetchProduct(apiType: .getProductList) {  [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self.allProductsData = product
                    self.categoryProductData = product
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
        congigureNavigationBar()
    }
    
    private func setUpSubviews() {
        view.addSubview(searchBar)
        view.addSubview(noResultsView)
        view.addSubview(categoryCollectionView)
        view.addSubview(productsCollectionView)
        view.addSubview(basketButton)
    }
    
    private func setUpConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
            $0.width.equalTo(343)
        }
        
        noResultsView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(280)
            $0.leading.equalToSuperview().inset(88)
            $0.height.equalTo(266)
            $0.width.equalTo(200)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
            $0.height.equalTo(28)
            $0.leading.trailing.equalToSuperview()
        }
        
        productsCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
            $0.height.equalTo(228)
            $0.width.equalTo(166)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        basketButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-50)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
            $0.width.equalTo(168)
        }
    }
    
    private func congigureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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

// MARK: - ProductsCollectionViewCellDelegate
extension SearchViewController: ProductsCollectionViewCellDelegate {
    func updateTotalBasketAmount() {
        let realm = try! Realm()
        
        if let cartItems = try? realm.objects(CartItem.self) {
            updateBasketButton(cartItems: cartItems)
        }
    }
    
    func updateBasketButton(cartItems: Results<CartItem>) {
        let totalAmount = cartItems.reduce(into: 0.0) { result, cartItem in
            if let product = allProductsData.first(where: { $0.id == cartItem.productId }),
               let itemPriceString = product.price,
               let itemPrice = Double(itemPriceString) {
                let itemTotal = Double(cartItem.quantity) * itemPrice
                result += itemTotal
            }
        }
        
        DispatchQueue.main.async {
            let buttonText = String(format: "Корзина %.0fс", totalAmount)
            self.basketButton.setTitle(buttonText, for: .normal)
        }
    }
    
    
    // надо удалить просто на время          // -
    func resetBasket() {
        let realm = try! Realm()
        
        // Находим все элементы в корзине
        let cartItems = realm.objects(CartItem.self)
        
        // Удаляем все элементы из корзины
        try! realm.write {
            realm.delete(cartItems)
        }
        
        // Обновляем UI после обнуления корзины
        updateBasketButton(cartItems: realm.objects(CartItem.self))
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
            cell.delegate = self
    
            // Добавьте Gesture Recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
            cell.addGestureRecognizer(tapGesture)
            
            return cell
        }
        fatalError("Unexpected collection view")
    }
    
    @objc func handleCellTap(_ gesture: UITapGestureRecognizer) {
           // Получите индекс нажатой ячейки
           if let indexPath = productsCollectionView.indexPathForItem(at: gesture.location(in: productsCollectionView)) {
               // Создайте экземпляр вашего нового контроллера
               let detailViewController = ProductDetailViewController()

               // Например, передайте данные продукта
               detailViewController.selectedProduct = allProductsData[indexPath.row]

               // Установите стиль модальной презентации
               detailViewController.modalPresentationStyle = .custom
               detailViewController.transitioningDelegate = self

               // Добавьте его на экран
               present(detailViewController, animated: true, completion: nil)
           }
       }

       // MARK: - UIViewControllerTransitioningDelegate

       func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
           return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
       }

}


// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let category = categoryData[indexPath.item].name
            let label = UILabel()
            label.text = category
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.sizeToFit()
            
            let width = label.frame.width + 34
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
            
        } else if collectionView == productsCollectionView {
            let numberOfColumns: CGFloat = 2
            let totalSpacing = 2 * 16 + max(0, numberOfColumns - 1) * 11
            let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
            let cellHeight: CGFloat = 228
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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


// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let selectedCategory = categoryData[indexPath.item].id
            filterProductsByCategory(selectedCategory)
        }
    }

    private func filterProductsByCategory(_ categoryId: Int) {
        // Фильтруем продукты по выбранной категории
        if categoryId == 0 {
            allProductsData = categoryProductData
        } else {
            // Фильтруем продукты по выбранной категории, учитывая nil
            allProductsData = categoryProductData.filter { $0.category == categoryId || ($0.category == nil && categoryId == 0) }
        }

        // Загружаем корзину для выбранной категории   // здесь надо менять/логика не работает
        if let cartItems = cartData[categoryId] {
            updateBasketButton(cartItems: cartItems)
        } else {
            let realm = try! Realm()
            let cartItems = realm.objects(CartItem.self)
            cartData[categoryId] = cartItems
            updateBasketButton(cartItems: cartItems)
        }

        // Обновляем коллекцию продуктов
        productsCollectionView.reloadData()
    }
}


// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterProductsBySearchText(searchText)
    }
    
    private func filterProductsBySearchText(_ searchText: String) {
        if searchText.isEmpty {
            // Если поисковый запрос пуст, показать все продукты
            allProductsData = categoryProductData
        } else {
            // Фильтровать продукты по поисковому запросу
            allProductsData = categoryProductData.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        
        if allProductsData.isEmpty {
            self.view.addSubview(noResultsView)
        } else {
            noResultsView.removeFromSuperview()
        }
        
        self.productsCollectionView.reloadData()
    }
}

