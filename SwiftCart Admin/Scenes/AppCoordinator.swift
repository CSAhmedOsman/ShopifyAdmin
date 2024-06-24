//
//  AppCoordinator.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.authVCName) as! AuthViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoAddPriceRule(product: ProductDetail? = nil){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.priceRuleDetail) as! AddPriceRuleViewController
//        vc.viewModel = ViewModel(service: RemoteService())
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoAddProduct(product: ProductDetail? = nil){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.productDetail) as! AddProductViewController
        vc.viewModel = ProductViewModel(service: RemoteService())
        vc.coordinator = self
        vc.product = product
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoHome() {
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: K.Main.homeVCName) as! HomeViewController
        homeVC.coordinator = self
        homeVC.viewModel = ProductViewModel(service: RemoteService())
        homeVC.tabBarItem = UITabBarItem(title: K.Title.home, image: K.SystemImage.home, tag: 0)

        let inventoryVC = storyboard.instantiateViewController(withIdentifier: K.Main.inventoryVCName) as! InventoryViewController
        inventoryVC.coordinator = self
        inventoryVC.viewModel = InventoryViewModel(service: RemoteService())
        inventoryVC.tabBarItem = UITabBarItem(title: K.Title.inventory, image: K.SystemImage.inventory, tag: 1)

        let couponsVC = storyboard.instantiateViewController(withIdentifier: K.Main.couponsVCName) as! CouponsViewController
        couponsVC.coordinator = self
        couponsVC.tabBarItem = UITabBarItem(title: K.Title.coupons, image: K.SystemImage.coupons, tag: 2)
                
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeVC, inventoryVC, couponsVC]
        if let tabBarColor = K.Assets.Color.viewBackground{
            tabBar.tabBar.backgroundColor = tabBarColor
        }
        
        navigationController.pushViewController(tabBar, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}
