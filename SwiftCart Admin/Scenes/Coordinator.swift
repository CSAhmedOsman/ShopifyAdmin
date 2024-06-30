//
//  Coordinator.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
}

