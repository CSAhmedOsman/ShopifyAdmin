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
        
        let defaults = UserDefaults.standard
        let isLogined = defaults.bool(forKey: K.Enums.Auth.userStatus)
        
        navigationController.navigationBar.isHidden = true
        
        if isLogined{
            gotoHome()
        } else {
            gotoAuth()
        }
    }
    
    func gotoAuth(){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.authVCName) as! AuthViewController
        vc.coordinator = self
        vc.viewModel = AuthViewModel()
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
        
        let priceRulesVC = storyboard.instantiateViewController(withIdentifier: K.Main.priceRulesVCName) as! PriceRulesViewController
        priceRulesVC.coordinator = self
        priceRulesVC.viewModel = PriceRulesViewModel(service: RemoteService())
        priceRulesVC.tabBarItem = UITabBarItem(title: K.Title.coupons, image: K.SystemImage.coupons, tag: 2)
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: K.Main.profileVCName) as! ProfileViewController
        profileVC.coordinator = self
        profileVC.tabBarItem = UITabBarItem(title: K.Title.profile, image: K.SystemImage.profile, tag: 3)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeVC, inventoryVC, priceRulesVC, profileVC]
        if let tabBarColor = K.Assets.Color.viewBackground{
            tabBar.tabBar.backgroundColor = tabBarColor
        }
        
        navigationController.pushViewController(tabBar, animated: true)
    }
    
    func gotoDiscounts(with id: Int64){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.discountsVCName) as! DiscountViewController
            
        vc.viewModel = DiscountViewModel(priceRuleId: id, service: RemoteService())
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoAddPriceRule(priceRule: PriceRule? = nil){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.priceRuleDetail) as! AddPriceRuleViewController
            
        vc.viewModel = PriceRulesViewModel(service: RemoteService())
        vc.coordinator = self
        vc.priceRule = priceRule
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
    
    func gotoAboutUs(){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.aboutUsVCName) as! AboutUsViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoContactUs(){
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.contactUsVCName) as! ContactUsViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
    
    func logout(){
        navigationController.popToRootViewController(animated: true)

        let defaults = UserDefaults.standard
        defaults.set(false, forKey: K.Enums.Auth.userStatus)
    }
}
