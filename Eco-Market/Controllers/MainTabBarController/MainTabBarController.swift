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
        let mainViewController = MainViewController()
        mainViewController.title = "Главная"
        mainViewController.tabBarItem.image = UIImage(named: "main_icon")
        mainViewController.tabBarItem.selectedImage = UIImage(named: "main_icon_selected")?.withRenderingMode(.alwaysOriginal)
        
        let basketViewController = BasketViewController()
        basketViewController.title = "Корзина"
        basketViewController.tabBarItem.image = UIImage(named: "basket_icon")
        basketViewController.tabBarItem.selectedImage = UIImage(named: "basket_icon_selected")?.withRenderingMode(.alwaysOriginal)

        let storyViewController = StoryViewController()
        storyViewController.title = "История"
        storyViewController.tabBarItem.image = UIImage(named: "story_icon")
        storyViewController.tabBarItem.selectedImage = UIImage(named: "story_icon_selected")?.withRenderingMode(.alwaysOriginal)

        let informationViewController = InfoViewController()
        informationViewController.title = "Инфо"
        informationViewController.tabBarItem.image = UIImage(named: "info_icon")
        informationViewController.tabBarItem.selectedImage = UIImage(named: "info_icon_selected")?.withRenderingMode(.alwaysOriginal)

        viewControllers = [mainViewController, basketViewController, storyViewController, informationViewController]
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

