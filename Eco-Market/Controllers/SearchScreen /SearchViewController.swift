//
//  SearchViewController.swift
//  Eco-Market
//
//  Created by anjella on 17/12/23.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    var selectedProduct: ProductCategoryModel?
    weak var delegate: ProductsCollectionViewCellDelegate?
    private var blurView: UIVisualEffectView?
    
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
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        let textField = search.searchTextField
        
        search.placeholder = "Быстрый поиск"
        search.barTintColor = UIColor(white: 0.973, alpha: 1)
        search.tintColor = .lightGray
        search.layer.cornerRadius = 16
        search.clipsToBounds = true
        
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .black
        textField.backgroundColor = UIColor(white: 0.973, alpha: 1)
        
        search.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        
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
            cell.product = allProductsData[indexPath.item]
            return cell
        }
        fatalError("Unexpected collection view")
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
        }  else if collectionView == productsCollectionView {
            let selectedProduct = allProductsData[indexPath.item]
            showProductDetail(for: selectedProduct)
        }
    }
    
    private func filterProductsByCategory(_ categoryId: Int) {
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
        
        productsCollectionView.reloadData()
    }
    
    private func showProductDetail(for product: ProductModel) {
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.selectedProduct = product
        productDetailViewController.delegate = self
        
        let blurEffect = UIBlurEffect(style: .dark)  // размытие надо исправить  
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.alpha = 0.8
        blurView?.frame = view.bounds
        blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView?.tag = 123
        blurView?.removeFromSuperview()
        view.addSubview(blurView!)
        
        let sheetController = UISheetPresentationController(presentedViewController: productDetailViewController, presenting: nil)
        sheetController.detents = [.medium()]
        sheetController.prefersGrabberVisible = true
        sheetController.delegate = self
        
        productDetailViewController.modalPresentationStyle = .custom
        productDetailViewController.transitioningDelegate = self
        
        present(productDetailViewController, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate
extension SearchViewController: UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.detents = [.medium()]
        presentationController.prefersGrabberVisible = true
        presentationController.delegate = self
        presentationController.prefersGrabberVisible = false
        
        return presentationController
    }
    
    func presentationController(_ presentationController: UIPresentationController, shouldDismiss presented: UIViewController) -> Bool {
        return true
    }
}

// MARK: - UISheetPresentationControllerDelegate
extension SearchViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        // Если выбрана нижняя точка привязки (detent), то удаляем размытие
        if sheetPresentationController.selectedDetentIdentifier == .medium {
            blurView?.removeFromSuperview()
        }
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
    
    func resetBasket() {  // надо удалить просто на время          // -
        let realm = try! Realm()
        let cartItems = realm.objects(CartItem.self)
        try! realm.write {
            realm.delete(cartItems)
        }
        updateBasketButton(cartItems: realm.objects(CartItem.self))
    }
}

extension SearchViewController: ProductDetailDelegate {
    func didAddToCart(product: ProductModel, quantity: Int) {
        let realm = try! Realm()
        try! realm.write {
            if let existingCartItem = realm.objects(CartItem.self).filter("productId == %@", product.id).first {
                existingCartItem.quantity += quantity
            } else {
                let newCartItem = CartItem()
                newCartItem.productId = product.id ?? 0
                newCartItem.quantity = quantity
                realm.add(newCartItem)
            }
        }
        updateBasketButton(cartItems: try! realm.objects(CartItem.self))
    }

    func removeFromCart(product: ProductModel, quantity: Int) {
        let realm = try! Realm()
        
        try! realm.write {
            if let existingCartItem = realm.objects(CartItem.self).filter("productId == %@", product.id).first {
                existingCartItem.quantity -= quantity
                if existingCartItem.quantity <= 0 {
                    realm.delete(existingCartItem)
                }
            }
        }
        
        updateBasketButton(cartItems: try! realm.objects(CartItem.self))
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterProductsBySearchText(searchText)
    }
    
    private func filterProductsBySearchText(_ searchText: String) {
        if searchText.isEmpty {
            allProductsData = categoryProductData
        } else {
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

