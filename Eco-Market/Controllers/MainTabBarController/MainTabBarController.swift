//
//  MainTabBarController.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .white
    }

    private func setupTabBar() {
        let mainViewController = ViewController()
        mainViewController.title = "Главная"
        mainViewController.tabBarItem.image = UIImage(named: "main_icon")
        mainViewController.tabBarItem.selectedImage = UIImage(named: "main_icon_selected")?.withRenderingMode(.alwaysOriginal)
        
        let cartViewController = ViewController()
        cartViewController.title = "Корзина"
        cartViewController.tabBarItem.image = UIImage(named: "cart_icon")
        cartViewController.tabBarItem.selectedImage = UIImage(named: "cart_icon_selected")?.withRenderingMode(.alwaysOriginal)

        let orderHistoryViewController = ViewController()
        orderHistoryViewController.title = "История"
        orderHistoryViewController.tabBarItem.image = UIImage(named: "history_icon")
        orderHistoryViewController.tabBarItem.selectedImage = UIImage(named: "history_icon_selected")?.withRenderingMode(.alwaysOriginal)

        let informationViewController = ViewController()
        informationViewController.title = "Инфо"
        informationViewController.tabBarItem.image = UIImage(named: "info_icon")
        informationViewController.tabBarItem.selectedImage = UIImage(named: "info_icon_selected")?.withRenderingMode(.alwaysOriginal)

        viewControllers = [mainViewController, cartViewController, orderHistoryViewController, informationViewController]
        selectedIndex = 0
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        tabBar.tintColor = ColorConstants.mainGreen
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }

}

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

