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
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: false)
//    }
//    
//    func gotoAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}
