//
//  ViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = "\(Date())"
    }
    @IBAction func gotoAnother(_ sender: Any) {
//        coordinator?.gotoAuth()
    }
}
