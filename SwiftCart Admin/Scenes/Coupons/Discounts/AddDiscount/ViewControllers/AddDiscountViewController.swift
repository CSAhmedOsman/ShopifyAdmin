//
//  AddDiscountViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import UIKit

class AddDiscountViewController: UIViewController {
    
    @IBOutlet weak var tfDiscountCode: UITextField!
    
    var bindDataToBackScreen: (String) -> () = {_ in }
    
    var value = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfDiscountCode.text = value
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        if sender.tag == 5{
            bindDataToBackScreen(value)
        }
        
        self.dismiss(animated: true)
    }
    
}
