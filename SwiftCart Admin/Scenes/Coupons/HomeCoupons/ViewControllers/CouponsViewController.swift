//
//  CouponsViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 18/06/2024.
//

import UIKit

class CouponsViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPriceRule(_ sender: Any) {
        coordinator?.gotoAddPriceRule()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
