//
//  ProductDetailViewController.swift
//  Eco-Market
//
//  Created by anjella on 21/12/23.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var selectedProduct: ProductModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        setupControllerSize()
    }

    func setupControllerSize() {
        // Получаем размеры экрана
        let screenSize = UIScreen.main.bounds.size

        // Создаем констрейнт для высоты контроллера
        let heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: screenSize.height / 2)

        // Активируем констрейнт
        NSLayoutConstraint.activate([heightConstraint])
    }
}


import UIKit

class HalfModalPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let height = containerView.frame.height / 2
        return CGRect(x: 0, y: containerView.frame.height - height, width: containerView.frame.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        // Добавьте тень или другие анимации, если нужно
    }

    override func dismissalTransitionWillBegin() {
        // Добавьте анимации при закрытии, если нужно
    }
}
