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
        
//        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.productDetail) as! AddProductViewController
        
        let vc = storyboard.instantiateViewController(withIdentifier: K.Main.authVCName) as! AuthViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func gotoHome() {
        let storyboard = UIStoryboard(name: K.Main.storyboardName, bundle: Bundle.main)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: K.Main.homeVCName) as! HomeViewController
        homeVC.coordinator = self
        homeVC.viewModel = ProductViewModel(service: RemoteService())
        homeVC.tabBarItem = UITabBarItem(title: K.Title.home, image: K.SystemImage.home, tag: 0)

        let couponsVC = storyboard.instantiateViewController(withIdentifier: K.Main.couponsVCName) as! CouponsViewController
        couponsVC.coordinator = self
        couponsVC.tabBarItem = UITabBarItem(title: K.Title.coupons, image: K.SystemImage.coupons, tag: 1)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeVC, couponsVC]
        if let tabBarColor = K.Assets.Color.viewBackground{
            tabBar.tabBar.backgroundColor = tabBarColor
        }
        
        navigationController.pushViewController(tabBar, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}


//class AuthCoordinator: Coordinator {
//
//    var childCoordinators = [Coordinator]()
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
////        let vc = AuthViewControllers.instantiate()
////        vc.coordinator = self
////        navigationController.pushViewController(vc, animated: false)
//    }
//
//    func finish() {
//        navigationController.popViewController(animated: true)
//    }
//
////    func gotoAnother() {
////        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
////        let vc = storyboard.instantiateViewController(withIdentifier: "tab")
////
////        vc.coordinator = self
////        navigationController.pushViewController(vc, animated: true)
////    }
//
//}
