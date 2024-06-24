//
//  EditQuntatyViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 24/06/2024.
//

import UIKit

class EditQuntatyViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbOrValue: UILabel!

    var bindDataToInventoryScreen: (Int) -> () = {_ in }
    
    var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbValue.text = "\(value)"
        lbOrValue.text = "Original: \(value)"
        mainView.layer.cornerRadius = 16
    }
    
    @IBAction func add(_ sender: UIButton) {
        switch sender.tag{
        case 1:
            value += 1
        case 2:
            value -= 1
        default:
            break
        }
        lbValue.text = "\(value)"
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        if sender.tag == 5{
            bindDataToInventoryScreen(value)
        }
        
        self.dismiss(animated: true)
    }
    
}
