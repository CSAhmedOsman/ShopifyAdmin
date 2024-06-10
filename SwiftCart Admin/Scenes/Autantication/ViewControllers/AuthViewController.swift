//
//  ViewController.swift
//  SwiftCart
//
//  Created by Mac on 30/05/2024.
//

import UIKit

class AuthViewController: UIViewController {
    weak var coordinator: AppCoordinator?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    @IBAction func login(sender: UIButton){
        coordinator?.gotoHome()
    }
}
