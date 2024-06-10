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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func gotoHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
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