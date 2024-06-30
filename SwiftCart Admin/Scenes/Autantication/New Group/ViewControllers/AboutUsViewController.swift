//
//  AboutUsViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import UIKit

class AboutUsViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBack(_ sender: Any) {
        coordinator?.finish()
    }
}
